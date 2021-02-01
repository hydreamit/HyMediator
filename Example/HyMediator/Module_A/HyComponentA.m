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
        [HyMediator addComponent:@"A" cls:self];
    });
}

- (RACSignal *)signal_push:(UINavigationController *)nav {
    
    HyTestAViewController *vc = HyTestAViewController.new;
    vc.rightItemCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        return HyMediator.component(@"B").signal(@"push", nav);
    }];
    vc.rightItemCommand.allowsConcurrentExecution = YES;
    vc.backgroundColorSignal = vc.rightItemCommand.executionSignals.switchToLatest;
    
    [nav pushViewController:vc animated:YES];
    
    return [RACSignal return:vc];
}

@end
