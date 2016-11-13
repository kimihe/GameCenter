//
//  Player.m
//  UserInput
//
//  Created by 周祺华 on 2016/11/13.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#define kTHRESHOLD 10
#import "Player.h"

@implementation Player

- (void) draw {
    [super draw];
    
    //Stop movement
    if (speed.x > 0 && touchPoint.x < pos.x) speed.x = 0;
    if (speed.x < 0 && touchPoint.x > pos.x) speed.x = 0;
    if (speed.y > 0 && touchPoint.y < pos.y) speed.y = 0;
    if (speed.y < 0 && touchPoint.y > pos.y) speed.y = 0;
}

- (void) setTouch: (CGPoint) point {
    touchPoint = point;
    
    CGFloat xDelta = touchPoint.x - pos.x;
    CGFloat yDelta = touchPoint.y - pos.y;
    
    // x,y任何一个的差值小于阈值就都保持图像静止
    if (fabs(xDelta)<kTHRESHOLD || fabs(yDelta)<kTHRESHOLD) {
        return;
    }
    
    speed.x = xDelta/20; //deltaX
    speed.y = yDelta/20; //deltaY
}

@end