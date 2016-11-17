
#import "Player.h"
#import "GameManager.h"

@implementation Player

- (void) draw {           
    pos.x+=speed.x;
    pos.y+=speed.y;        
    [self drawFrame];
            
    //Stop movement
    if (speed.x > 0 && touchPoint.x < pos.x) speed.x = 0;
    if (speed.x < 0 && touchPoint.x > pos.x) speed.x = 0;
    if (speed.y > 0 && touchPoint.y < pos.y) speed.y = 0;
    if (speed.y < 0 && touchPoint.y > pos.y) speed.y = 0;  
    
    //Swiped too far
    if (pos.x > W-frameW) { pos.x = W-frameW; speed.x = 0; }
    if (pos.x < 0) { pos.x = 0; speed.x = 0; }
    if (pos.y > H-frameH) { pos.y = H-frameH; speed.y = 0; }
    if (pos.y < 0) { pos.y = 0; speed.y = 0; } 
}  

- (void) hit {
    [argghPic drawAtPoint: CGPointMake(pos.x, pos.y - argghPic.size.height)];
    health--;
    if (health == 0) {
        [[GameManager getInstance] setState: GAME_OVER];        
    } 
}

- (void) setHealth: (int) hlth {
    health = hlth;
}

- (int) getHealth {
    return health;
}

@end