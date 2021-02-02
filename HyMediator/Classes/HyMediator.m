//
//  HyMediator.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import "HyMediator.h"
#import <objc/message.h>


@interface HyBaseComponent ()
@property (nonatomic,assign) NSString *componentName;
@end

@implementation HyBaseComponent

- (RACSignal *(^)(NSString *key, id input))signal {
    @weakify(self);
    return ^RACSignal *(NSString *key, id input) {
        @strongify(self);
        return [self signalForKey:key input:input];
    };
}
- (RACSubject *(^)(NSString *key, id input))subject {
    @weakify(self);
    return ^RACSubject *(NSString *key, id input) {
        @strongify(self);
        return [self subjectForKey:key input:input];
    };
    
}
- (RACCommand *(^)(NSString *key, id input))command {
    @weakify(self);
    return ^RACCommand *(NSString *key, id input) {
        @strongify(self);
        return [self commandForKey:key input:input];
    };
}

- (RACSignal *)signalForKey:(NSString *)key input:(id)input {
    
    if ([self isMemberOfClass:HyBaseComponent.class]) {
        return [RACSignal error:[self notFoundComponentError]];
    }
    
    NSString *selString = [NSString stringWithFormat:@"signal_%@:", key];
    SEL siganlSel = NSSelectorFromString(selString);
    if ([self respondsToSelector:siganlSel]) {
        return ((RACSignal *(*)(id, SEL, id))objc_msgSend)(self , siganlSel, input);
    }
    
    return [RACSignal error:[self notFoundKeyError:key]];
}

- (RACSubject *)subjectForKey:(NSString *)key input:(id)input {
    
    if ([self isMemberOfClass:HyBaseComponent.class]) {
        return (id)[RACSignal error:[self notFoundComponentError]];
    }
    
    NSString *selString = [NSString stringWithFormat:@"subject_%@:", key];
    SEL subjectSel = NSSelectorFromString(selString);
    if ([self respondsToSelector:subjectSel]) {
        return ((RACSubject *(*)(id, SEL, id))objc_msgSend)(self , subjectSel, input);
    }
    
    return (id)[RACSignal error:[self notFoundKeyError:key]];
}

- (RACCommand *)commandForKey:(NSString *)key input:(id)input {
    
    if ([self isMemberOfClass:HyBaseComponent.class]) {
        return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable commandInput) {
            return (id)[RACSubject error:[self notFoundComponentError]];
        }];
    }
    
    NSString *selString = [NSString stringWithFormat:@"command_%@:", key];
    SEL commandSel = NSSelectorFromString(selString);
    if ([self respondsToSelector:commandSel]) {
        return ((RACCommand *(*)(id, SEL, id))objc_msgSend)(self , commandSel, input);
    }
    
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable commandInput) {
        return [self commandSignalForKey:key input:input commandInput:commandInput];
    }];
}

- (RACSignal *)commandSignalForKey:(NSString *)key
                             input:(id)input
                      commandInput:(id)commandInput {
    
    id handleInput = [self commandInputHandlerForKey:key input:input commandInput:commandInput];
    return [self signalForKey:key input:handleInput];
}

- (id)commandInputHandlerForKey:(NSString *)key
                          input:(id)input
                   commandInput:(id)commandInput {
    return input;
    //return commandInput ?: input;
}

- (NSError *)notFoundComponentError {
    NSDictionary *userInfo =
    @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"没有找到组件:%@", self.componentName]};
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain
                                                code:-404
                                            userInfo:userInfo];
    return error;
}

- (NSError *)notFoundKeyError:(NSString *)key {
    NSDictionary *userInfo =
    @{NSLocalizedDescriptionKey : [NSString stringWithFormat:@"在组件%@实现类:%@中, 没有找到key:%@的实现", self.componentName, NSStringFromClass(self.class), key]};
    NSError *error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain
                                                code:-403
                                            userInfo:userInfo];
    return error;
}

@end




@interface HyMediator ()
@property (nonatomic,strong) NSMutableDictionary<NSString *, Class<HyComponentSignalProtocol>> *componentDict;
@property (nonatomic,strong) NSMutableDictionary<NSString *, id<HyComponentSignalProtocol>> *componentCacheDict;
@property (nonatomic,strong) dispatch_semaphore_t semaphore;
@end
@implementation HyMediator
+ (instancetype)shareInstance {
    static HyMediator *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[super allocWithZone:NULL] init];
        _instance.componentDict = @{}.mutableCopy;
        _instance.componentCacheDict = @{}.mutableCopy;
        _instance.semaphore = dispatch_semaphore_create(1);
    });
    return _instance;
}
+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}
- (id)copyWithZone:(NSZone *)zone {
    return self;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return self;
}

+ (void)addComponent:(NSString *)component
                 cls:(Class<HyComponentSignalProtocol>)cls
               cache:(BOOL)cache {
    
    if (!component.length || !cls) {  return; }
    
    HyMediator *mediator = [self shareInstance];
    dispatch_semaphore_wait(mediator.semaphore, DISPATCH_TIME_FOREVER);
    [mediator.componentDict setObject:cls forKey:component];
    if (cache) {
        [mediator.componentCacheDict setObject:(id)@1 forKey:component];
    }
    dispatch_semaphore_signal(mediator.semaphore);
}

+ (void)removeComponent:(NSString *)component {
    if (!component) { return; }
    
    HyMediator *mediator = [self shareInstance];
    dispatch_semaphore_wait(mediator.semaphore, DISPATCH_TIME_FOREVER);
    [mediator.componentDict removeObjectForKey:component];
    [mediator.componentCacheDict removeObjectForKey:component];
    dispatch_semaphore_signal(mediator.semaphore);
}

+ (id<HyComponentSignalProtocol> (^)(NSString *cp))component {
    return ^id<HyComponentSignalProtocol> (NSString *cp) {
        if (!cp.length) { cp = @""; }
        
        HyMediator *mediator = [self shareInstance];
        
        Class cls = [mediator.componentDict objectForKey:cp];
        if (!cls) { cls = HyBaseComponent.class; }
        
        id<HyComponentSignalProtocol> cpt = [mediator.componentCacheDict objectForKey:cp];
        BOOL cache = [cpt isKindOfClass:NSNumber.class];
        
        if (!cpt || cache) {
            cpt = [[cls alloc] init];
            if ([cpt isKindOfClass:HyBaseComponent.class]) {
                ((HyBaseComponent *)cpt).componentName = cp;
            }
            if (cache) {
                [mediator.componentCacheDict setObject:cpt forKey:cp];
            }
        }
        return cpt;
    };
}

@end
