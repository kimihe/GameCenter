//
//  MainView.h
//  MyGameTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

extern int W;
extern int H;

@interface MainView : UIView
- (int)getRndBetween:(int)bottom and:(int)top;
@end
