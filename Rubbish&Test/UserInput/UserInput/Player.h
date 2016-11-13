//
//  Player.h
//  UserInput
//
//  Created by 周祺华 on 2016/11/13.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "Zombie.h"

@interface Player : Zombie {
    CGPoint touchPoint;
}

- (void) setTouch: (CGPoint) touchPoint;

@end
