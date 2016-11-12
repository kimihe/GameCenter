//
//  MainView.m
//  GameLoopTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "MainView.h"

int W=320;
int H=480;

@implementation MainView

- (void) drawRect: (CGRect) rect
{
    W = rect.size.width;
    H = rect.size.height;
    
    static int cnt = 0;
    cnt++;
    NSLog(@"Game Loop: %i", cnt);
    
    if (!carBlueImage) {
        carBlueImage = [UIImage imageNamed: @"car_blue.png"];
    }
    
    static int y = 0;
    y += 3;
    if (y > H) y = -100;
    [carBlueImage drawAtPoint: CGPointMake(W/2, y)];
}

@end
