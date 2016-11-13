//
//  MainView.h
//  GameLoopTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sprite.h"
#import "Zombie.h"
#import "Player.h"

extern int W;
extern int H;

@interface MainView : UIView <UIAccelerometerDelegate> {
    //NSMutableArray *sprites;
    UIAccelerometer *accelerometer;
    UIImage *background;
    Player *player;
    bool useSensor;
}

- (int) getRndBetween: (int) bottom and: (int) top;
- (void) accelerometer: (UIAccelerometer *) accelerometer
         didAccelerate: (UIAcceleration *) acceleration;

- (void)clearView;

@end
