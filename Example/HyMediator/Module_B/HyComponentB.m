//
//  HyComponentB.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import "HyComponentB.h"
#import "HyTestBViewController.h"


@implementation HyComponentB

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HyMediator addComponent:@"B" cls:self];
    });
}

- (RACSignal *)signal_push:(UINavigationController *)input {
    HyTestBViewController *vc = HyTestBViewController.new;
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

@end
