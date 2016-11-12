//
//  MainView.h
//  GameLoopTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sprite.h"

extern int W;
extern int H;

@interface MainView : UIView {
    Sprite *zombie;
    NSMutableArray *sprites;
}

- (void)clearView;

@end
