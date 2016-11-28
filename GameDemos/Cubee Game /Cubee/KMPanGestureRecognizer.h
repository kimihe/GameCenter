//
//  KMPanGestureRecognizer.h
//  Cubee
//
//  Created by 周祺华 on 2016/11/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  识别出的KMPanGestureRecognizerDirection方向
 */
typedef NS_ENUM(NSUInteger, KMPanGestureRecognizerDirection) {
    /**
     *  向右
     */
    KMPanGestureRecognizerDirectionRight = 1 << 0,
    /**
     *  向左
     */
    KMPanGestureRecognizerDirectionLeft  = 1 << 1,
    /**
     *  向上
     */
    KMPanGestureRecognizerDirectionUp    = 1 << 2,
    /**
     *  向下
     */
    KMPanGestureRecognizerDirectionDown  = 1 << 3,
    /**
     *  无法判断出结果
     */
    KMPanGestureRecognizerDirectionUnknown = 0
};

@protocol KMPanGestureRecognizerDelegate <NSObject>

@optional
- (void)gestureBeganAtPoint:(CGPoint)beganPoint;
- (void)gestureEndedAtPoint:(CGPoint)endedPoint withBeganPoint:(CGPoint)beganPoint gestureDirection:(KMPanGestureRecognizerDirection)diretion;

@end

@interface KMPanGestureRecognizer : UIGestureRecognizer

@property(assign, nonatomic)CGPoint touchBeganPoint;
@property(assign, nonatomic)CGPoint touchEndedPoint;
@property(assign, nonatomic)KMPanGestureRecognizerDirection direction;

@property(weak, nonatomic)id <KMPanGestureRecognizerDelegate> panDelegate;

@end
