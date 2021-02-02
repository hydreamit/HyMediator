//
//  HyComponentA.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import "HyComponentA.h"
#import "HyTestAViewController.h"


@implementation HyComponentA

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HyMediator addComponent:@"A" cls:self cache:NO];
    });
}

- (RACSignal *)signal_push:(UINavigationController *)nav {
    
    HyTestAViewController *vc = HyTestAViewController.new;
    
    vc.rightItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return HyMediator.component(@"B").signal(@"push", nav);
    }];
    vc.rightItemCommand.allowsConcurrentExecution = YES;
    vc.backgroundColorSignal = vc.rightItemCommand.executionSignals.switchToLatest;
    
    // 添加需要监听的 其他组件信号
    @weakify(vc);
    [[HyMediator.component(@"B").subject(@"rightItemEvent", nil) takeUntil:vc.rac_willDeallocSignal] subscribeNext:^(id  _Nullable x) {
        @strongify(vc);
        [vc changeTitle:(NSString *)x];
    }];

  
    [nav pushViewController:vc animated:YES];
    
    return [RACSignal return:vc];
}

@end
