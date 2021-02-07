//
//  HyTestBViewController.h
//  HyMediator
//
//  Created by hydreamit on 02/01/2018.
//  Copyright (c) 2018 hydreamit. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HyTestBViewController : UIViewController

@property (nonatomic,copy) void (^touchAction)(void);
@property (nonatomic,copy) void (^rightItemAction)(NSString *);

@end

NS_ASSUME_NONNULL_END
