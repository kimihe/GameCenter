//
//  Zombie.h
//  AnimationTest
//
//  Created by 周祺华 on 2016/11/12.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "Sprite.h"

@interface Zombie : Sprite
{
    UIImage *argghPic;
}

- (void)hitTest:(NSMutableArray *)sprites;

@end
