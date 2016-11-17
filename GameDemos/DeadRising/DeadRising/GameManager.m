
#import "GameManager.h"

int W=320;
int H=480;

@implementation GameManager

#pragma mark ============================= Init Methods ===============================

+ (GameManager*) getInstance  {
    
    static GameManager* gameManager;
		
	if (!gameManager) {
        gameManager = [[GameManager alloc] init];
		[gameManager preloader];            
	}
	    
    return gameManager;
}

- (void) preloader {
    sprites = [[NSMutableArray alloc] initWithCapacity:20];
    newSprites = [[NSMutableArray alloc] initWithCapacity:20];
    destroyableSprites = [[NSMutableArray alloc] initWithCapacity:20];
    
    background = [self getPic: @"background.png"];    
    
    state = LOAD_GAME;
}

- (void) loadGame { 
    [sprites removeAllObjects];
    [newSprites removeAllObjects];
    [destroyableSprites removeAllObjects];      
    
    saved = 0;
    lost = 0;
    savedMax = 20;
    
    for (int i=0; i<5; i++) { 
        int px = [self getRndBetween: 20 and: W-20];
        int py = [self getRndBetween: H/2 and: H-20];
        [self createSprite: REANIMATOR 
                     speed: CGPointMake(0, 0) 
                       pos: CGPointMake(px, py)]; 
    }
        
    [self createSprite: PLAYER 
                 speed: CGPointMake(0, 0) 
                   pos: CGPointMake(W/2, H/2)];
    
    for (int i=0; i<W/50; i++) {  
        int sy    = [self getRndBetween: 1 and: 3];
        int px    = i * 52 + 10;
        int py    = [self getRndBetween: -100 and: 0];
        [self createSprite: CAR 
                     speed: CGPointMake(0, sy) 
                       pos: CGPointMake(px, py)];
    }  
}

- (void) createSprite: (int) type 
                speed: (CGPoint) sxy 
                  pos: (CGPoint) pxy {    
    
    if (type == PLAYER) { 
        player = [[Player alloc] initWithPic: @"player_4f.png" 
                                    frameCnt: 4 
                                   frameStep: 3
                                       speed: sxy
                                         pos: pxy];     
        [player setType: PLAYER];  
        [player setHealth: 99];
        [newSprites addObject: player];
    } else if (type == ZOMBIE) {
        Zombie *zombie = [[Zombie alloc] initWithPic: @"zombie_4f.png" 
                                            frameCnt: 4 
                                           frameStep: 3
                                               speed: sxy
                                                 pos: pxy];     
        [zombie setType: ZOMBIE];
        [newSprites addObject: zombie];
    } else if (type == CAR) {
        int carType = [self getRndBetween: 0 and: 8];
        NSString *pic = @"car_blue.png";
        if (carType < 3) pic = @"car_green.png";
        else if (carType < 6) pic = @"car_red.png";
        Car *car = [[Car alloc] initWithPic: pic
                                   frameCnt: 1 
                                  frameStep: 0
                                      speed: sxy
                                        pos: pxy];     
        [car setType: CAR];
        [newSprites addObject: car];
    } else if (type == ANIMATION) {        
        Animation *ani = [[Animation alloc] initWithPic: @"smoke_6f.png"
                                               frameCnt: 6 
                                              frameStep: 3
                                                  speed: sxy
                                                    pos: pxy];        
        [ani setType: ANIMATION];
        [newSprites addObject: ani];
    } else if (type == REANIMATOR) {        
        Reanimator *reanimator = [[Reanimator alloc] initWithPic: @"skull.png"
                                                   frameCnt: 1 
                                                  frameStep: 0
                                                      speed: sxy
                                                        pos: pxy];        
        [reanimator setType: REANIMATOR];
        [newSprites addObject: reanimator];
    } else {
        NSLog(@"ERROR: Unknown Sprite-Type: %i", type);
    }    
}

- (void) createExplosionFor: (Sprite *) sprite {    
    CGPoint p = [Animation getOriginBasedOnCenterOf: [sprite getRect] 
                                             andPic: @"smoke_6f.png"
                                       withFrameCnt: 6];    
    [self createSprite: ANIMATION 
                 speed: CGPointMake(0, 0) 
                   pos: p];        
}

#pragma mark ============================= Game Handler ===============================

- (void) touchBegan: (CGPoint) p {    
    [self handleStates];
    if (state == PLAY_GAME) {
        for (Sprite *sprite in sprites) { 
            if ([sprite isActive]) {             
                if ([sprite getType] == ZOMBIE || [sprite getType] == PLAYER) {
                    [(Zombie *) sprite setTouch: p];
                } 
            }   
        } 
    }    
}

- (void) touchMoved: (CGPoint) p {
    if (state == PLAY_GAME) {
        [self touchBegan: p];
    }    
}

- (void) touchEnded {
    if (state == PLAY_GAME) {
        for (Sprite *sprite in sprites) { 
            if ([sprite isActive]) {             
                if ([sprite getType] == ZOMBIE || [sprite getType] == PLAYER) {
                    [(Zombie *) sprite touchEnded];
                } 
            }   
        } 
    }    
}

- (void) handleStates {   
    if (state == START_GAME) {
        state = PLAY_GAME;
    }
    else if (state == GAME_OVER || state == GAME_WON) {
        state = LOAD_GAME;
    }
}

- (void) drawStatesWithFrame: (CGRect) frame { 
    W = frame.size.width;
    H = frame.size.height;
    switch (state) {
        case LOAD_GAME: 
            [self loadGame];
            state = START_GAME;
            break;
        case START_GAME:
//            [background drawAtPoint: CGPointMake(0, 0)];
            [background drawInRect:[[UIScreen mainScreen] bounds]];
            [self drawString: @"Welcome!" at: CGPointMake(5, 5)];
            [self drawString: @"Use the green zombie to" at: CGPointMake(5, 25)];
            [self drawString: @"touch the skulls and to" at: CGPointMake(5, 45)];
            [self drawString: @"re-animate the dead." at: CGPointMake(5, 65)];
            [self drawString: @"Drag as much zombies over" at: CGPointMake(5, 85)];
            [self drawString: @"the green line as possible." at: CGPointMake(5, 105)];
            [self drawString: @"Avoid cars to stay undead." at: CGPointMake(5, 125)];
            [self drawString: @"Tap screen to start!" at: CGPointMake(5, 145)];
            break;    
        case PLAY_GAME:
            [self playGame];
            break;
        case GAME_OVER:
//            [background drawAtPoint: CGPointMake(0, 0)];
            [background drawInRect:[[UIScreen mainScreen] bounds]];
            [self drawString: @"G A M E  OVER" at: CGPointMake(5, 5)];
            [self drawString: @"You are dead again." at: CGPointMake(5, 25)];
            [self drawString: [NSString stringWithFormat:@"Saved: %i", saved]
                          at: CGPointMake(5, 45)];
            [self drawString: [NSString stringWithFormat:@"Lost: %i", lost]
                          at: CGPointMake(5, 65)];
            [self drawString: @"Tap screen!" at: CGPointMake(5, 85)];
            break;  
        case GAME_WON:
//            [background drawAtPoint: CGPointMake(0, 0)];
            [background drawInRect:[[UIScreen mainScreen] bounds]];
            [self drawString: @"Y O U  M A D E  I T !" at: CGPointMake(5, 5)];
            [self drawString: @"Prepare for the next round." at: CGPointMake(5, 25)];
            [self drawString: [NSString stringWithFormat:@"Saved: %i", saved]
                          at: CGPointMake(5, 45)];
            [self drawString: [NSString stringWithFormat:@"Lost: %i", lost]
                          at: CGPointMake(5, 65)];
            [self drawString: @"Tap screen!" at: CGPointMake(5, 85)];
            break;             
        default: NSLog(@"ERROR: Unknown state: %i", state);
            break;
    }    
}	 

- (void) savedZombie {
    saved++;
}

- (void) lostZombie {
    lost++;
}

- (void) playGame {   
//    [background drawAtPoint: CGPointMake(0, 0)];
    [background drawInRect:[[UIScreen mainScreen] bounds]];
    [self manageSprites];             
    [self renderSprites];
    [self drawTargetLine];
    
    NSString *hud = [NSString stringWithFormat: @"HLT: %i SVD: %i/%i LST: %i", 
                     [player getHealth], saved, savedMax, lost]; 
    [self drawString: hud at: CGPointMake(5, 5)];
       
    if (saved >= savedMax) {
        state = GAME_WON;
    }
} 

- (void) checkSprite: (Sprite *) sprite {
    if ([sprite getType] == ZOMBIE || [sprite getType] == PLAYER) {                
        for (Sprite *sprite2test in sprites) {        
            if ([sprite2test getType] == CAR) {              
                if ([sprite checkColWithSprite: sprite2test]) {                
                    [sprite hit];
                }
            }
            if ([sprite getType] == PLAYER && [sprite2test getType] == REANIMATOR) { 
                if ([sprite checkColWithSprite: sprite2test]) {                
                    [(Reanimator *) sprite2test reanimate];
                }    
            }
        } 
    }  
}

#pragma mark ============================= Helper Methods ===============================

- (void) setState: (int) stt {
    state = stt;
}

- (void) manageSprites {
    //NSLog(@"Sprites: %i destroyable: %i new: %i", [sprites count], [destroyableSprites count], [newSprites count]);
    
    //Cleanup 
    for (Sprite *destroyableSprite in destroyableSprites) { 
        for (Sprite *sprite in sprites) { 
            if (destroyableSprite == sprite) { 
                [sprites removeObject: sprite];
                break;
            }
        }   
    }  
    
    for (Sprite *newSprite in newSprites){ 
        [sprites addObject: newSprite];   
    } 
    
    [destroyableSprites removeAllObjects]; 
    [newSprites removeAllObjects];
}

- (void) renderSprites {
    for (Sprite *sprite in sprites) { 
        if ([sprite isActive]) {             
            [self checkSprite: sprite];
            [sprite draw]; 
        } else {
            [destroyableSprites addObject: sprite]; 
        }    
    } 
}

- (NSMutableDictionary *) getDictionary {
	if (!dictionary) { //Hashtable
		dictionary = [[NSMutableDictionary alloc] init]; 
	}
	return dictionary;
}

- (UIImage *) getPic: (NSString*) picName {
	@try { 
		UIImage *pic = [[self getDictionary] objectForKey: picName];
		if (!pic) {
			pic = [UIImage imageNamed: picName]; 
			[[self getDictionary] setObject: pic forKey: picName];
            int memory = pic.size.width*pic.size.height*4;
			NSLog(@"%@ stored, Size: %i KB", picName, memory/1024);
		}          
		return pic;
	} 
	@catch (id theException) {
		NSLog(@"ERROR: %@ not found!", picName);		
	} 
	return nil;
}

- (int) getRndBetween: (int) bottom and: (int) top {		
	int rnd = bottom + (arc4random() % (top+1-bottom)); 
	return rnd;
} 

- (void) drawString: (NSString *) str at: (CGPoint) p {
//    UIFont *uif = [UIFont fontWithName: @"Verdana-Italic" size: 20];
//	CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 0, 0, 0, 1);
//    [str drawAtPoint: p withFont: uif];
    
    // String
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributesDic = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:20.0],
                                    NSParagraphStyleAttributeName : style,
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:0.0 green:0.0 blue:0 alpha:1.0]
                                    };
    [str drawInRect:CGRectMake(p.x, p.y, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height) withAttributes:attributesDic];
} 

- (int) getTargetY {
    return 135;
}

- (void) drawTargetLine {
    CGContextRef gc = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(gc, 0, 1, 0, 0.5);
	CGContextSetLineWidth(gc, 5);       
	CGContextMoveToPoint(gc, 0, [self getTargetY]); 
	CGContextAddLineToPoint(gc, W, [self getTargetY]);
 	CGContextDrawPath(gc, kCGPathStroke);
}
@end
