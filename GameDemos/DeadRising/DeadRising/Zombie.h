
#import "Sprite.h"

@interface Zombie : Sprite {
    UIImage *argghPic; 
    int hitCnt;
    CGPoint touchPoint;
    bool touchAction;
    bool saved;
}

- (void) setTouch: (CGPoint) touchPoint;
- (void) touchEnded;

@end
