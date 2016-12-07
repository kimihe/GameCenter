//
//  KMGameView.h
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KMGameView;
@protocol KMGameViewDelegate <NSObject>

@optional

- (void)gameView:(KMGameView *)view willKickAwayCubesWithCount:(NSInteger)count;
- (void)gameView:(KMGameView *)view didKickAwayCubesWithCount:(NSInteger)count;

@end

@interface KMGameView : UIView

extern NSInteger dropsPerRow;
extern CGSize DROP_SIZE;

@property (weak, nonatomic)id <KMGameViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)randomlyDropCubes;

@end

