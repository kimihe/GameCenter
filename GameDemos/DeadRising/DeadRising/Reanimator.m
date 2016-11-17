
#import "Reanimator.h"
#import "GameManager.h"

@implementation Reanimator

- (void) reanimate { 
    counter++;
    if (counter % 5 == 0) {
        int px = [[GameManager getInstance] getRndBetween: 10 and: W-30];
        int py = [[GameManager getInstance] getRndBetween: H and: H+100];
        [[GameManager getInstance] createSprite: ZOMBIE 
                                          speed: CGPointMake(0, -1) 
                                            pos: CGPointMake(px, py)]; 
        [[GameManager getInstance] drawString: @"Re-Animate!" 
                                           at: CGPointMake(pos.x-50, pos.y-30)];
    }
}

@end