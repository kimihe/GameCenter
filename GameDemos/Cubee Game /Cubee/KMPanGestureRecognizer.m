//
//  KMPanGestureRecognizer.m
//  Cubee
//
//  Created by 周祺华 on 2016/11/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "KMPanGestureRecognizer.h"
#import <UIKit/UIGestureRecognizerSubclass.h>

#import "KMMathHelper.h"

static const double kGradientThreshold = 0.5;

@implementation KMPanGestureRecognizer

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    _touchBeganPoint = [touch locationInView:self.view];
    
    if ([self.panDelegate respondsToSelector:@selector(gestureBeganAtPoint:)]) {
        [self.panDelegate gestureBeganAtPoint:_touchBeganPoint];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = [touches anyObject];
    _touchEndedPoint = [touch locationInView:self.view];
    
    _direction = [self checkPanGestureDirection];
    self.state = UIGestureRecognizerStateRecognized;
    
    if ([self.panDelegate respondsToSelector:@selector(gestureEndedAtPoint:withBeganPoint:gestureDirection:)]) {
        [self.panDelegate gestureEndedAtPoint:_touchEndedPoint withBeganPoint:_touchBeganPoint gestureDirection:_direction];
    }
}

- (KMPanGestureRecognizerDirection)checkPanGestureDirection
{
    CGFloat xDelta = _touchEndedPoint.x - _touchBeganPoint.x;
    CGFloat yDelta = _touchEndedPoint.y - _touchBeganPoint.y;
    
    double k = [KMMathHelper getGradientFromPoint1:_touchBeganPoint point2:_touchEndedPoint];
    
    // 先处理斜率无限大的特殊情况
    if (isnan(k)) {
        if (yDelta < 0) {
            return KMPanGestureRecognizerDirectionUp;
        }
        if (yDelta > 0) {
            return KMPanGestureRecognizerDirectionDown;
        }
        if (yDelta == 0) {
            return KMPanGestureRecognizerDirectionUnknown;
        }
    }
    
    // 再处理正常的一般情况
    if (fabs(k) <= kGradientThreshold) {
        if (xDelta > 0) {
            return KMPanGestureRecognizerDirectionRight;
        }
        if (xDelta < 0) {
            return KMPanGestureRecognizerDirectionLeft;
        }
        return KMPanGestureRecognizerDirectionUnknown;
    }
    if (fabs(k) >= (1.0/kGradientThreshold)) {
        if (yDelta < 0) {
            return KMPanGestureRecognizerDirectionUp;
        }
        if (yDelta > 0) {
            return KMPanGestureRecognizerDirectionDown;
        }
        return KMPanGestureRecognizerDirectionUnknown;
    }
    return KMPanGestureRecognizerDirectionUnknown;
}


@end
