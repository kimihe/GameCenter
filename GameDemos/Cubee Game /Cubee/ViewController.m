//
//  ViewController.m
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "KMGameView.h"


@interface ViewController () <KMGameViewDelegate>
{
    KMGameView *_gameView;
    UILabel *_scoreLabel;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init sth
- (void)initView
{
    _gameView = [[KMGameView alloc] initWithFrame:self.view.frame];
    UIImage *background = [UIImage imageNamed:@"background"];
    _gameView.contentMode = UIViewContentModeScaleAspectFill;
    _gameView.layer.contents = (__bridge id _Nullable)(background.CGImage);
    _gameView.delegate = self;
    [self.view addSubview:_gameView];
    
    
    UIButton *dropBtn = [[UIButton alloc] initWithFrame:CGRectMake(150, 100, 50, 30)];
    [dropBtn setTitle:@"drop" forState:UIControlStateNormal];
    [dropBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_gameView addSubview:dropBtn];
    
    
    _scoreLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, 20, 100, 30)];
    [_gameView addSubview:_scoreLabel];
}

- (void)btnAction:(UIButton *)sender
{
    [_gameView randomlyDropCubes];
}

#pragma mark - <KMGameViewDelegate>
- (void)gameViewDidKickAwayCubesWithCount:(NSInteger)count
{
    NSString *str = [NSString stringWithFormat:@"Score: %ld", (long)count];
    _scoreLabel.text = str;
}

@end
