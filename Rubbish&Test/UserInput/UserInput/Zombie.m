//
//  Zombie.m
//  AnimationTest
//
//  Created by 周祺华 on 2016/11/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "Zombie.h"

@implementation Zombie

- (id) initWithPic: (NSString *) picName
          frameCnt: (int) fcnt
         frameStep: (int) fstp
             speed: (CGPoint) sxy
               pos: (CGPoint) pxy {
    
    argghPic = [UIImage imageNamed: @"arggh.png"];
    
    return [super initWithPic: picName
                     frameCnt: fcnt
                    frameStep: fstp
                        speed: sxy
                          pos: pxy];
}

- (void) hitTest: (NSMutableArray *) sprites {
    for (Sprite *sprite in sprites) {
        if ([sprite getType] == CAR) {
            if ([self checkColWithSprite: sprite]){
                [argghPic drawAtPoint: CGPointMake(pos.x, pos.y - argghPic.size.height)];
            }
        }
    }
}


@end
