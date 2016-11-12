//
//  Sprite.m
//  AnimationTest
//
//  Created by 周祺华 on 2016/11/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "Sprite.h"

@implementation Sprite

-(id) initWithPic: (NSString *) picName
         frameCnt: (int) fcnt
        frameStep: (int) fstp
            speed: (CGPoint) sxy
              pos: (CGPoint) pxy {
    
    if (self = [super init]) {
        pic = [UIImage imageNamed: picName];
        speed = sxy;
        pos = pxy;
        cnt = 0;
        frameNr = 0;
        frameCnt = fcnt;
        frameStep = fstp;
    }
    
    return self;
}

- (void) draw {
    pos.x+=speed.x;
    pos.y+=speed.y;
    [self drawFrame];
}

- (void) drawFrame {
    int picW = pic.size.width;
    int frameW = picW/frameCnt;
    int frameH = pic.size.height;
    
    frameNr = [self updateFrame];
    NSLog(@"frameNr: %i", frameNr);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    pos.x = rintf(pos.x);
    CGContextClipToRect(ctx, CGRectMake(pos.x, pos.y, frameW, frameH));
    [pic drawAtPoint: CGPointMake(pos.x-frameNr*frameW, pos.y)];
    
    CGContextRestoreGState(ctx);
}

- (int) updateFrame {
    if (frameStep != 0) {
        if (frameStep == cnt) {
            cnt = 0;
            frameNr++;
            if (frameNr > frameCnt-1) {
                frameNr = 0;
            }
        }
        cnt++;
    }
    return frameNr;
}

@end
