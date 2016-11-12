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
    
    if (!zombie) {
        zombie = [[Sprite alloc] initWithPic: @"zombie_4f.png"
                                    frameCnt: 4
                                   frameStep: 5
                                       speed: CGPointMake(0, -3)
                                         pos: CGPointMake(W/2, H)];
    }
    
    [zombie draw];
    
    //Invasion
    if (!sprites) {
        sprites = [[NSMutableArray alloc] initWithCapacity: 30];
        
        for (int i=0; i<30; i++) {
            int fs = [self getRndBetween: 1 and: 10];
            int sy = [self getRndBetween: -3 and: -1];
            int px = [self getRndBetween: 0 and: W];
            int py = [self getRndBetween: H+100 and: H+200];
            Sprite *sprite = [[Sprite alloc] initWithPic: @"zombie_4f.png"
                                                frameCnt: 4
                                               frameStep: fs
                                                   speed: CGPointMake(0, sy)
                                                     pos: CGPointMake(px, py)];
            [sprites addObject: sprite];
        }
    }
    
    for (Sprite *sprite in sprites){
        [sprite draw];
    }

}

- (void)clearView
{
    [sprites removeAllObjects];
    sprites = nil;
    zombie = nil;
    
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
