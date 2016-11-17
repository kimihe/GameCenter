
#import "Animation.h"
#import "GameManager.h"

@implementation Animation

- (void) drawFrame {
    frameNr = [self updateFrame];
    if (cycleCnt == 1) {
        active = false;
    }  
    if (active) {        
        [self renderSprite];  	
    }    
}

+ (CGPoint) getOriginBasedOnCenterOf: (CGRect) rectMaster 
                              andPic: (NSString *) picName 
                        withFrameCnt: (int) fcnt {    
    UIImage *picSlave = [[GameManager getInstance] getPic: picName];
    
    int xmm = rectMaster.origin.x + rectMaster.size.width/2;
    int ymm = rectMaster.origin.y + rectMaster.size.height/2;
    
    int xs = xmm-picSlave.size.width/2/fcnt;
    int ys = ymm-picSlave.size.height/2;

    return CGPointMake(xs, ys);
}

@end
