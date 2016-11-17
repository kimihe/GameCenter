
#import <UIKit/UIKit.h>
#import "Sprite.h"
#import "Zombie.h"
#import "Player.h"
#import "Car.h"
#import "Animation.h"
#import "Reanimator.h"

extern int W; 
extern int H;

enum states {
    LOAD_GAME,
    START_GAME,
    PLAY_GAME,
    GAME_OVER,
    GAME_WON
}; 

@interface GameManager : NSObject {
    int state; 	
    UIImage *background;
    Player *player;
    
    NSMutableArray *sprites; 
    NSMutableArray *newSprites; 
    NSMutableArray *destroyableSprites;      
    NSMutableDictionary* dictionary; 
    
    int saved;       
    int lost;       
    int savedMax;   
}

//Init Methods
+ (GameManager *) getInstance;
- (void) preloader;
- (void) loadGame;
- (void) createSprite: (int) type 
                speed: (CGPoint) sxy 
                  pos: (CGPoint) pxy;
- (void) createExplosionFor: (Sprite *) sprite;

//Game Handler
- (void) touchBegan: (CGPoint) p;
- (void) touchMoved: (CGPoint) p;
- (void) touchEnded;
- (void) handleStates;
- (void) drawStatesWithFrame: (CGRect) frame; 
- (void) savedZombie; 
- (void) lostZombie;
- (void) playGame; 
- (void) checkSprite: (Sprite *) sprite;

//Helper Methods
- (void) setState: (int) stt;
- (void) manageSprites;
- (void) renderSprites;
- (int) getRndBetween: (int) bottom and: (int) top;
- (void) drawString: (NSString *) str at: (CGPoint) p;
- (NSMutableDictionary*) getDictionary;
- (UIImage *) getPic: (NSString*) picName;
- (int) getTargetY;
- (void) drawTargetLine;

@end
