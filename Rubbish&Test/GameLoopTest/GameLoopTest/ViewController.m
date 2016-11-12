//
//  ViewController.m
//  GameLoopTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    UIView *greenView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    greenView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:greenView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
