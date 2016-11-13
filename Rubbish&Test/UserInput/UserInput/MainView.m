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

- (void) drawRect: (CGRect) rect {
    W = rect.size.width;
    H = rect.size.height;
    
    if (!background) {
        background= [UIImage imageNamed:@"background.png"];
        useSensor = NO;
    }
    else {
        [background drawInRect:rect];
    }
    
    NSString *str = @"Touch-Control";
    if (useSensor) {
        str = @"Motion-Control";
    }
    UIFont *uif = [UIFont fontWithName:@"Verdana-Italic" size: 40];
    [str drawAtPoint:CGPointMake(10, 10) withFont: uif];
    
    if (!accelerometer) {
        accelerometer = [UIAccelerometer sharedAccelerometer];
        accelerometer.delegate = self;
        accelerometer.updateInterval = 0.033;
    }
    
    if (!player) {
        player = [[Player alloc] initWithPic: @"zombie_4f.png"
                                    frameCnt: 4
                                   frameStep: 3
                                       speed: CGPointMake(0, 0)
                                         pos: CGPointMake(W/2, H/2)];
        [player setType: PLAYER];
    }
    
    [player draw];
}

- (void) touchesBegan: (NSSet *) touches withEvent: (UIEvent *) event {
    
    [self setMultipleTouchEnabled: YES];
    
    NSSet *allTouches = [event allTouches];
    NSLog(@"Tap count: %lu", (unsigned long)[allTouches count]);
    
    if ([allTouches count] == 2) {
        if (useSensor) {
            useSensor = NO;
        } else {
            useSensor = YES;
        }
    }
    
    if (!useSensor) {
        //Multi-Touch
        for (UITouch *touch in [allTouches allObjects]){
            CGPoint p = [touch locationInView: self];
            int x = p.x;
            int y = p.y;
            NSLog(@"Multi-Touch at %i, %i", x, y);
        }
        
        //Single Tap
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView: self];
        int xt = p.x;
        int yt = p.y;
        NSLog(@"Single-Touch at %i, %i", xt, yt);
        
        [player setTouch: p];
    }     
}

- (void) touchesMoved: (NSSet *) touches withEvent: (UIEvent *) event {
    if (!useSensor) {
        UITouch *touch = [touches anyObject];
        CGPoint p = [touch locationInView:self];
        [player setTouch: p];
        int x = p.x;
        int y = p.y;
        NSLog(@"Touch moves at %i, %i", x, y);
    }
}

- (void) accelerometer: (UIAccelerometer *) sensor
         didAccelerate: (UIAcceleration *) acceleration {
    if (useSensor) {
        float x = acceleration.x;
        float y = acceleration.y;
        float z = acceleration.z;
        NSLog(@"Sensor: x: %f y: %f z: %f", x, y, z);
        int factor = 15;
        [player setSpeed: CGPointMake(x*factor, -y*factor)];
    }
}

- (void)clearView
{
//    [sprites removeAllObjects];
//    sprites = nil;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
//    CGContextClearRect(ctx, self.bounds);
    CGContextRelease(ctx);
    ctx = NULL;
}

- (int) getRndBetween: (int) bottom and: (int) top {
    int rnd = bottom + (arc4random() % (top+1-bottom));
    return rnd;
}

@end
