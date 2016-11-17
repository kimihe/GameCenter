
#import <UIKit/UIKit.h>

enum types {    
    PLAYER,
    ZOMBIE,
    CAR,
    ANIMATION,
    REANIMATOR
};

@interface Sprite : NSObject {    
    UIImage *pic;       
    CGPoint speed;      
    CGPoint pos;        
    int cnt;               
    int frameNr;        
    int frameCnt;            
    int frameStep;      
    int frameW;         
    int frameH;         
    int type;           
    int cycleCnt;       
    bool forceIdleness; 
    bool active;        
}

-(id) initWithPic: (NSString *) picName 
         frameCnt: (int) fcnt 
        frameStep: (int) fstp
            speed: (CGPoint) sxy 
              pos: (CGPoint) pxy;
- (void) draw;
- (void) drawFrame;
- (void) renderSprite;
- (int) updateFrame;
- (CGRect) getRect;
- (bool) checkColWithPoint: (CGPoint) p;
- (bool) checkColWithSprite: (Sprite *) sprite;
- (void) hit;
- (void) setType: (int) spriteType;
- (int) getType;
- (void) setSpeed: (CGPoint) sxy;
- (CGPoint) getSpeed;
- (bool) isActive;

@end
