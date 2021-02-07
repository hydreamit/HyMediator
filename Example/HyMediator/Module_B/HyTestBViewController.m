//
//  HyTestBViewController.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2018.
//  Copyright (c) 2018 hydreamit. All rights reserved.
//

#import "HyTestBViewController.h"


@implementation HyTestBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = UIColor.orangeColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全局事件B" style:UIBarButtonItemStyleDone target:self action:@selector(action)];
}

- (void)action {
    !self.rightItemAction ?: self.rightItemAction(@"全局事件B");
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController popViewControllerAnimated:YES];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,
                                 (int64_t)(.1 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), self.touchAction);
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
