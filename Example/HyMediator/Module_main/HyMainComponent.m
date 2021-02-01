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
        [HyMediator addComponent:@"main" cls:self];
    });
}

- (RACSignal *)signal_mainVc:(id)input {

    HyTestViewController *vc = HyTestViewController.new;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    vc.rightItemCommand = HyMediator.component(@"A").command(@"push", nav);
    return [RACSignal return:nav];
}


@end
