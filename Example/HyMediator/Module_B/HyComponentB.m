//
//  HyComponentB.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2018.
//  Copyright (c) 2018 hydreamit. All rights reserved.
//

#import "HyComponentB.h"
#import "HyTestBViewController.h"


@interface HyComponentB ()
@property (nonatomic,strong) RACSubject *rightItemSubject;
@end

@implementation HyComponentB

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HyMediator addComponent:@"B" cls:self cache:YES];
    });
}

- (RACSignal *)signal_push:(UINavigationController *)input {
    
    HyTestBViewController *vc = HyTestBViewController.new;
    vc.rightItemAction = ^(NSString *string){
        [self.rightItemSubject sendNext:string];
    };
    
    return
    [[RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        [input pushViewController:vc animated:YES];
        vc.touchAction = ^{
            [subscriber sendNext:UIColor.blueColor];
            [subscriber sendCompleted];
        };
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }] takeUntil:vc.rac_willDeallocSignal];
}

- (RACSubject *)subject_rightItemEvent:(id)input {
    return self.rightItemSubject;
}


- (RACSubject *)rightItemSubject {
    if (!_rightItemSubject) {
        _rightItemSubject = [RACSubject subject];
    }
    return _rightItemSubject;
}


@end
