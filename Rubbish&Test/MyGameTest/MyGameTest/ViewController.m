//
//  ViewController.m
//  MyGameTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "MainView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MainView *mainView = [[MainView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view addSubview:mainView];
    
    self.view.backgroundColor = [UIColor clearColor];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
