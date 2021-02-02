//
//  HyTestAViewController.m
//  HyMediator
//
//  Created by hydreamit on 02/01/2019.
//  Copyright (c) 2019 hydreamit. All rights reserved.
//

#import "HyTestAViewController.h"

@interface HyTestAViewController ()

@end

@implementation HyTestAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColor.grayColor;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Module B" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.rightItemCommand;
    
    if (self.backgroundColorSignal) {
        RAC(self.view, backgroundColor) = self.backgroundColorSignal;
    }
}

- (void)changeTitle:(NSString *)title {
    self.navigationItem.title = title;
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
