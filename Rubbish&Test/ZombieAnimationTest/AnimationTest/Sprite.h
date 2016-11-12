//
//  Sprite.h
//  AnimationTest
//
//  Created by 周祺华 on 2016/11/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Sprite : NSObject {
    UIImage *pic;
    CGPoint speed;
    CGPoint pos;
    int cnt;
    int frameNr;
    int frameCnt;
    int frameStep;
}

-(id) initWithPic: (NSString *) picName
         frameCnt: (int) fcnt
        frameStep: (int) fstp
            speed: (CGPoint) sxy
              pos: (CGPoint) pxy;
- (void) draw;
- (void) drawFrame;
- (int) updateFrame;

@end
