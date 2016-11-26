//
//  KMGameView.h
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KMGameViewDelegate <NSObject>

@optional

- (void)gameViewWillKickAwayCubesWithCount:(NSInteger)count;
- (void)gameViewDidKickAwayCubesWithCount:(NSInteger)count;

@end

@interface KMGameView : UIView

extern NSInteger dropsPerRow;
extern CGSize DROP_SIZE;

@property (weak, nonatomic)id <KMGameViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)randomlyDropCubes;

@end

