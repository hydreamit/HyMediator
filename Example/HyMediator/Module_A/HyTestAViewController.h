//
//  HyTestAViewController.h
//  HyMediator
//
//  Created by hydreamit on 02/01/2018.
//  Copyright (c) 2018 hydreamit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTestAViewController : UIViewController

@property (nonatomic,strong) RACCommand *rightItemCommand;

@property (nonatomic,strong) RACSignal<UIColor *> *backgroundColorSignal;

- (void)changeTitle:(NSString *)title;


@end

NS_ASSUME_NONNULL_END
