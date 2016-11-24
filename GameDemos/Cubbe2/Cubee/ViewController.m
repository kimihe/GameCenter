//
//  ViewController.m
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "ViewController.h"
#import "KMGameView.h"
#import "KMAnimatorManager.h"
#import "KMCubeBehavior.h"
#import "UIColor+KMColorHelper.h"

@interface ViewController () <UIDynamicAnimatorDelegate>
{
    KMCubeBehavior *_cubeBehavior;
    KMGameView *_gameView;
    KMAnimatorManager *_animator;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initData];
    [self addTapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Init sth
- (void)initData
{
    _gameView = [[KMGameView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:_gameView];
    
    _animator = [[KMAnimatorManager alloc] initWithReferenceView:_gameView];
    _animator.delegate = self;
    
    _cubeBehavior = [[KMCubeBehavior alloc] init];
    [_animator addBehavior:_cubeBehavior];
}

- (void)addTapGesture
{
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_gameView addGestureRecognizer:tapGR];
}

- (void)tapAction:(UITapGestureRecognizer *)sender
{
    [self dropCudes];
}

#pragma mark - Cubes Dropping
- (void)dropCudes
{
    NSLog(@"here!");
    
    CGFloat x = arc4random()%dropsPerRow * DROP_SIZE.width;
    CGFloat y = _gameView.bounds.origin.y;
    
    UIView *dropView = [[UIView alloc] initWithFrame:CGRectMake(x, y, DROP_SIZE.width, DROP_SIZE.width)];
    dropView.backgroundColor = [UIColor randomFiveColor];
    [_gameView addSubview:dropView];
    [_cubeBehavior addItem:dropView];

}

#pragma mark - Remove
- (void)removeCompletedRows
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];
    NSMutableArray *dropsFoundOneRow = [[NSMutableArray alloc] init];
    NSInteger dropsCountOneRow = 0;
    
    // 此处(x, y)为了能够提高判断精度，建议取点为方块中心，不要取边角，会无法检测到
    for (CGFloat y =_gameView.bounds.size.height-DROP_SIZE.height/2; y >0; y -=DROP_SIZE.height) {
        for (CGFloat x = DROP_SIZE.width/2; x <_gameView.bounds.size.width; x +=DROP_SIZE.width) {
            // 检测(x, y)这个点所在的view
            UIView *hitView = [_gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            
            // 如果返回的view的父视图是_gameView,就说明它是方块
            if ([[hitView superview] isEqual:_gameView]) {
                
                [dropsFoundOneRow addObject:hitView];
                dropsCountOneRow ++;
            }
        }
        
        if (dropsCountOneRow == dropsPerRow) {
            [dropsToRemove addObjectsFromArray:dropsFoundOneRow];
        }
        
        [dropsFoundOneRow removeAllObjects];
        dropsCountOneRow = 0;
    }
    
    [self kickAwayDrops:dropsToRemove];
}

- (void)removeThreeSameColor
{
    NSMutableArray *dropsToRemove = [[NSMutableArray alloc] init];

    // 此处(x, y)为了能够提高判断精度，建议取点为方块中心，不要取边角，会无法检测到
    for (CGFloat y =_gameView.bounds.size.height-DROP_SIZE.height/2; y >0; y -=DROP_SIZE.height) {
        for (CGFloat x = DROP_SIZE.width/2; x <_gameView.bounds.size.width; x +=DROP_SIZE.width) {
            // 检测(x, y)这个点所在的view
            UIView *hitView = [_gameView hitTest:CGPointMake(x, y) withEvent:NULL];
            if ([[hitView superview] isEqual:_gameView]) {
                
                NSArray *arr = [self checkCrossAt:hitView];
                if (arr) {
                    [dropsToRemove addObjectsFromArray:arr];
                }
            }
        }
    }
    
    [self kickAwayDrops:dropsToRemove];
}

#pragma mark - Support Methods
- (NSArray *)checkHorizontalAt:(UIView *)aView
{
    UIView *centerView = aView;
    UIColor *centerColor = aView.backgroundColor;
    CGFloat x = centerView.center.x;
    CGFloat y = centerView.center.y;
    CGFloat squreWidth = DROP_SIZE.width;
    
    
    UIView *leftView = [_gameView hitTest:CGPointMake(x-squreWidth, y) withEvent:NULL];
    if (![[leftView superview] isEqual:_gameView]) {
        return nil;
    }
    
    UIView *rightView = [_gameView hitTest:CGPointMake(x+squreWidth, y) withEvent:NULL];
    if (![[rightView superview] isEqual:_gameView]) {
        return nil;
    }
    
    UIColor *leftColor = leftView.backgroundColor;
    UIColor *rightColor = rightView.backgroundColor;
    
    if ([centerColor isEqual:leftColor] && [centerColor isEqual:rightColor]) {
        NSArray *arr = [NSArray arrayWithObjects:leftView, centerView, rightView, nil];
        return arr;
    }

    return nil;
}

- (NSArray *)checkHorizontalVerticalAt:(UIView *)aView
{
    UIView *centerView = aView;

    UIColor *centerColor = aView.backgroundColor;
    CGFloat x = centerView.center.x;
    CGFloat y = centerView.center.y;
    CGFloat squreWidth = DROP_SIZE.width;
    
    
    UIView *leftView = [_gameView hitTest:CGPointMake(x-squreWidth, y) withEvent:NULL];
    UIView *rightView = [_gameView hitTest:CGPointMake(x+squreWidth, y) withEvent:NULL];
    UIView *upperView = [_gameView hitTest:CGPointMake(x, y-squreWidth) withEvent:NULL];
    UIView *lowerView = [_gameView hitTest:CGPointMake(x, y+squreWidth) withEvent:NULL];

    UIColor *leftColor = leftView.backgroundColor;
    UIColor *rightColor = rightView.backgroundColor;
    UIColor *upperColor = upperView.backgroundColor;
    UIColor *lowerColor = lowerView.backgroundColor;
    
    NSMutableArray *totalArr = [NSMutableArray new];
    if ([centerColor isEqual:leftColor] && [centerColor isEqual:rightColor]) {
        NSArray *arr = [NSArray arrayWithObjects:leftView, centerView, rightView, nil];
        [totalArr addObjectsFromArray:arr];
    }
    if ([centerColor isEqual:upperColor] && [centerColor isEqual:lowerColor]) {
        NSArray *arr = [NSArray arrayWithObjects:upperView, centerView, lowerView, nil];
        [totalArr addObjectsFromArray:arr];
    }
    
    return totalArr;
}

- (NSArray *)checkCrossAt:(UIView *)aView
{
    UIView *centerView = aView;
    
    UIColor *centerColor = aView.backgroundColor;
    CGFloat x = centerView.center.x;
    CGFloat y = centerView.center.y;
    CGFloat squreWidth = DROP_SIZE.width;
    
    
    UIView *leftView = [_gameView hitTest:CGPointMake(x-squreWidth, y) withEvent:NULL];
    UIView *rightView = [_gameView hitTest:CGPointMake(x+squreWidth, y) withEvent:NULL];
    UIView *upperView = [_gameView hitTest:CGPointMake(x, y-squreWidth) withEvent:NULL];
    UIView *lowerView = [_gameView hitTest:CGPointMake(x, y+squreWidth) withEvent:NULL];
    
    
    UIView *upperLeftView = [_gameView hitTest:CGPointMake(x-squreWidth, y-squreWidth) withEvent:NULL];
    UIView *lowerLeftView = [_gameView hitTest:CGPointMake(x-squreWidth, y+squreWidth) withEvent:NULL];
    UIView *upperRightView = [_gameView hitTest:CGPointMake(x+squreWidth, y-squreWidth) withEvent:NULL];
    UIView *lowerRightView = [_gameView hitTest:CGPointMake(x+squreWidth, y+squreWidth) withEvent:NULL];
    
    
    UIColor *leftColor = leftView.backgroundColor;
    UIColor *rightColor = rightView.backgroundColor;
    UIColor *upperColor = upperView.backgroundColor;
    UIColor *lowerColor = lowerView.backgroundColor;
    
    UIColor *upperLeftColor = upperLeftView.backgroundColor;
    UIColor *lowerLeftColor = lowerLeftView.backgroundColor;
    UIColor *upperRightColor = upperRightView.backgroundColor;
    UIColor *lowerRightColor = lowerRightView.backgroundColor;
    
    NSMutableArray *totalArr = [NSMutableArray new];
    if ([centerColor isEqual:leftColor] && [centerColor isEqual:rightColor]) {
        NSArray *arr = [NSArray arrayWithObjects:leftView, centerView, rightView, nil];
        [totalArr addObjectsFromArray:arr];
    }
    if ([centerColor isEqual:upperColor] && [centerColor isEqual:lowerColor]) {
        NSArray *arr = [NSArray arrayWithObjects:upperView, centerView, lowerView, nil];
        [totalArr addObjectsFromArray:arr];
    }
    
    if ([centerColor isEqual:upperLeftColor] && [centerColor isEqual:lowerRightColor]) {
        NSArray *arr = [NSArray arrayWithObjects:upperLeftView, centerView, lowerRightView, nil];
        [totalArr addObjectsFromArray:arr];
    }
    if ([centerColor isEqual:upperRightColor] && [centerColor isEqual:lowerLeftColor]) {
        NSArray *arr = [NSArray arrayWithObjects:upperRightView, centerView, lowerLeftView, nil];
        [totalArr addObjectsFromArray:arr];
    }
    
    return totalArr;
}

- (void)kickAwayDrops:(NSArray *)drops
{
    for (UIView *drop in drops) {
        [_cubeBehavior removeItem:drop];
    }
        
    [UIView animateWithDuration:0.5 animations:^{
        
        for (UIView *drop in drops) {
            
            //设定炸飞后终点的位置
            int x = _gameView.bounds.size.width+DROP_SIZE.width;
            int y = - DROP_SIZE.height;
            drop.center = CGPointMake(x, y);
        }
        
    } completion:^(BOOL finished) {
        [drops makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }];
}

#pragma mark - <UIDynamicAnimatorDelegate>
- (void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    [self removeThreeSameColor];
}



@end
