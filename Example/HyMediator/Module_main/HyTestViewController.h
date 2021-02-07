//
//  HyTestViewController.h
//  HyMediator
//
//  Created by hydreamit on 02/01/2018.
//  Copyright (c) 2018 hydreamit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTestViewController : UIViewController

@property (nonatomic,strong) RACCommand *rightItemCommand;

@property (nonatomic,strong) RACSignal<UIColor *> *backgroundColorSignal;

@end

NS_ASSUME_NONNULL_END
