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
    
//    if (!sprites) {
//        sprites = [[NSMutableArray alloc] initWithCapacity: 2];
//        
//        Zombie *zombie = [[Zombie alloc] initWithPic: @"zombie_4f.png"
//                                            frameCnt: 4
//                                           frameStep: 5
//                                               speed: CGPointMake(0, -3)
//                                                 pos: CGPointMake(W/2, H)];
//        [zombie setType: ZOMBIE];
//        [sprites addObject: zombie];
//        
//        Sprite *car = [[Sprite alloc] initWithPic: @"car_red.png"
//                                         frameCnt: 1
//                                        frameStep: 0
//                                            speed: CGPointMake(0, 5)
//                                              pos: CGPointMake(W/2, 0)];
//        [car setType: CAR];
//        [sprites addObject: car];
//    }
//    
//    for (Sprite *sprite in sprites) {
//        if ([sprite getType] == ZOMBIE) {
//            [(Zombie *) sprite hitTest: sprites];
//        }
//        [sprite draw];
//    }
//    
//    return;
    
    if (!sprites) {
        sprites = [[NSMutableArray alloc] initWithCapacity: 30];
        
        for (int i=0; i<20; i++) {
            int fs = [self getRndBetween: 1 and: 10];
            int sy = [self getRndBetween: -3 and: -1];
            int px = [self getRndBetween: 0 and: W];
            int py = [self getRndBetween: H and: H+100];
            Zombie *zombie = [[Zombie alloc] initWithPic: @"zombie_4f.png"
                                                frameCnt: 4
                                               frameStep: fs
                                                   speed: CGPointMake(0, sy)
                                                     pos: CGPointMake(px, py)];
            [zombie setType: ZOMBIE];
            [sprites addObject: zombie];
        }
        
        for (int i=0; i<10; i++) {
            NSString *pic     = @"car_blue.png";
            if (i<3) pic      = @"car_green.png";
            else if (i<6) pic = @"car_red.png";
            int sy    = [self getRndBetween: 1 and: 3];
            int px    = [self getRndBetween: 0 and: W];
            int py    = [self getRndBetween: -100 and: 0];
            Sprite *car = [[Sprite alloc] initWithPic: pic
                                             frameCnt: 1
                                            frameStep: 0
                                                speed: CGPointMake(0, sy)
                                                  pos: CGPointMake(px, py)];
            [car setType: CAR];
            [sprites addObject: car];
        }
    }
    
    for (Sprite *sprite in sprites) {
        if ([sprite getType] == ZOMBIE) {
            [(Zombie *) sprite hitTest: sprites];
        }
        [sprite draw];
    }
}

- (void)clearView
{
    [sprites removeAllObjects];
    sprites = nil;
    
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
