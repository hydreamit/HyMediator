//
//  HyMainComponent.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import "HyMainComponent.h"
#import "HyTestViewController.h"


@implementation HyMainComponent

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [HyMediator addComponent:@"main" cls:self cache:NO];
    });
}

- (RACSignal *)signal_mainVc:(id)input {

    HyTestViewController *vc = HyTestViewController.new;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    // 处理自己组件的事件
    vc.rightItemCommand = HyMediator.component(@"A").command(@"push", nav);
    
    // 添加需要监听的 其他事件信号
    vc.backgroundColorSignal =
    [[HyMediator.component(@"B").subject(@"rightItemEvent", nil) map:^id _Nullable(id  _Nullable value) {
        return UIColor.greenColor;
    }] takeUntil:vc.rac_willDeallocSignal];
    
    return [RACSignal return:nav];
}


@end
