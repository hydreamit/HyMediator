//
//  HyTestViewController.h
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTestViewController : UIViewController

@property (nonatomic,strong) RACCommand *rightItemCommand;

@end

NS_ASSUME_NONNULL_END
