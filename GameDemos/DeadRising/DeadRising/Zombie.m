
#import "Zombie.h"
#import "GameManager.h"

@implementation Zombie

- (id) initWithPic: (NSString *) picName 
          frameCnt: (int) fcnt 
         frameStep: (int) fstp
             speed: (CGPoint) sxy 
               pos: (CGPoint) pxy {     
    
    self = [super initWithPic: picName 
                     frameCnt: fcnt 
                    frameStep: fstp
                        speed: sxy
                          pos: pxy];    
    
    argghPic = [[GameManager getInstance] getPic: @"arggh.png"];
    forceIdleness = true;
    hitCnt = 0;
    touchAction = false;
    saved = false;
    return self;
}

- (void) draw { 
    [super draw];
    
    //Stop movement
    if (speed.x > 0 && touchPoint.x < pos.x) speed.x = 0;
    if (speed.x < 0 && touchPoint.x > pos.x) speed.x = 0;
    if (speed.y > 0 && touchPoint.y < pos.y) speed.y = -1;
    if (speed.y < 0 && touchPoint.y > pos.y) speed.y = -1; 
    
    if (pos.y < [[GameManager getInstance] getTargetY]) {
        saved = true;
        [self setSpeed: CGPointMake(0, -10)];
        if (pos.y < -30) {
            active = false;
            [[GameManager getInstance] savedZombie];
        }    
    } else {
        saved = false;
    }
}

- (void) hit {
    if (!saved) {
        hitCnt++;
        [argghPic drawAtPoint: CGPointMake(pos.x, pos.y - argghPic.size.height)];
        if (hitCnt == 10) {
            active = false;
            [[GameManager getInstance] lostZombie];
            [[GameManager getInstance] createExplosionFor: self];
        }  
    }
}

- (void) setTouch: (CGPoint) point {     
    if ([self checkColWithPoint: point]) {
        touchAction = true;
    }
    if (touchAction && !saved) {
        touchPoint = point;
        speed.x = (touchPoint.x - pos.x)/20; //deltaX
        speed.y = (touchPoint.y - pos.y)/20; //deltaY  
    }
}

- (void) touchEnded {
    touchAction = false;    
}

@end
