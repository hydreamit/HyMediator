//
//  HyMediator.h
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveObjC/ReactiveObjC.h>
#import <UIKit/UIKit.h>



NS_ASSUME_NONNULL_BEGIN


@protocol HyComponentSignalProtocol <NSObject>
@property (nonatomic,assign,readonly) NSString *componentName;
- (RACSignal *(^)(NSString *key, id _Nullable input))signal;
- (RACSubject *(^)(NSString *key, id _Nullable input))subject;
- (RACCommand *(^)(NSString *key, id _Nullable input))command;
@end



/// 中间件组件基础实现类
@interface HyBaseComponent : NSObject<HyComponentSignalProtocol>
/// 组件子类重写方法 或  直接实现方法：signal_key:
- (RACSignal *)signalForKey:(NSString *)key input:(id)input;
/// 组件子类重写方法 或  直接实现方法：subject_key:
- (RACSubject *)subjectForKey:(NSString *)key input:(id)input;
/// 组件子类重写方法 或  直接实现方法：command_key:
- (RACCommand *)commandForKey:(NSString *)key input:(id)input;
- (RACSignal *)commandSignalForKey:(NSString *)key
                             input:(id)input
                      commandInput:(id)commandInput;
- (id)commandInputHandlerForKey:(NSString *)key
                          input:(id)input
                   commandInput:(id)commandInput;
@end




@interface HyMediator : NSObject

+ (void)addComponent:(NSString *)component cls:(Class<HyComponentSignalProtocol>)cls;
+ (void)removeComponent:(NSString *)component;

+ (id<HyComponentSignalProtocol> (^)(NSString *component))component;

@end

NS_ASSUME_NONNULL_END