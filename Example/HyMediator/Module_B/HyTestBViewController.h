//
//  HyTestBViewController.h
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTestBViewController : UIViewController

@property (nonatomic,copy) void (^touchAction)(void);

@end

NS_ASSUME_NONNULL_END
