//
//  KMMathHelper.m
//  BezierCurve_Test
//
//  Created by nali on 16/8/20.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import "KMMathHelper.h"

@implementation KMMathHelper

#pragma mark - 二维空间直角坐标系
+ (CGPoint)getMiddleFromPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    CGPoint middle = CGPointMake((point1.x+point2.x)/2,
                                 (point1.y+point2.y)/2);
    return middle;
}

+ (double)getDistanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    double xDiff = point1.x - point2.x;
    double yDiff = point1.y - point2.y;
    double distance = sqrt(xDiff*xDiff + yDiff*yDiff);
    return distance;
}

+ (CGPoint)getNewPointFromCurrentPoint:(CGPoint)currentPoint offset:(double)offset angle:(double)angle
{
    CGPoint newPoint = CGPointMake(currentPoint.x + offset*cos(angle),
                                   currentPoint.y + offset*sin(angle));
    return newPoint;
}

+ (CGPoint)getNewPointFromStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint rate:(double)rate
{
    double xDiff = endPoint.x - startPoint.x;
    double yDiff = endPoint.y - startPoint.y;
    double xOffset = xDiff*rate;
    double yOffset = yDiff*rate;
    
    CGPoint newPoint = CGPointMake(startPoint.x+xOffset, startPoint.y+yOffset);
    return newPoint;
}

+ (double)getGradientFromPoint1:(CGPoint)point1 point2:(CGPoint)point2
{
    double xDiff = point2.x - point1.x;
    double yDiff = point2.y - point1.y;
    if (xDiff == 0) {//斜率无限大咱就不算了
        return NAN;
    }
    else {
        double gradient = yDiff/xDiff;
        if (isnan(gradient)) {//斜率太大超过系统阈值
            return NAN;
        }
        return gradient;
    }
}

+ (BOOL)point1:(CGPoint)point1 EqualToPoint2:(CGPoint)point2
{
    if (point1.x==point2.x && point1.y==point2.y) {
        return YES;
    }
    return NO;
}

+ (BOOL)checkDistanceBetween:(CGPoint)p1 and:(CGPoint)p2 lessThan:(CGFloat)d
{
    CGFloat res = (p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y);
    if (res < d*d) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkDistanceBetween:(CGPoint)p1 and:(CGPoint)p2 lessThanSqure:(CGFloat)squre
{
    CGFloat res = (p1.x-p2.x)*(p1.x-p2.x)+(p1.y-p2.y)*(p1.y-p2.y);
    if (res < squre) {
        return YES;
    }
    
    return NO;
}

+ (BOOL)checkRect1:(CGRect)rect1 overlayWithRect2:(CGRect)rect2
{
    /**
     *  1. 对于二位直角坐标系中的两个矩形，判断是否有重叠，采用投影法；
     *  2. 将两个矩形分别投影到X轴和Y轴，每个坐标轴会有两个投影区间，四个点；
     *  3. 例如，对于X轴的投影，根据两个区间的左右端点，判断是否区间重叠，注意区间端点处的点重叠，不归为区间重叠！Y轴同理；
     *  4. 两个坐标轴的投影都有区间重叠，即说明矩形有重叠。
     */
    
    // project to X-axis
    struct KMMathInterval_RationalNumber rect1X = [self projectRect:rect1 toAxis:X];
    struct KMMathInterval_RationalNumber rect2X = [self projectRect:rect2 toAxis:X];
    
    // project to Y-axis
    struct KMMathInterval_RationalNumber rect1Y = [self projectRect:rect1 toAxis:Y];
    struct KMMathInterval_RationalNumber rect2Y = [self projectRect:rect2 toAxis:Y];
    
    if ([self checkInterval1:rect1X overlayWithInterval2:rect2X] &&
        [self checkInterval1:rect1Y overlayWithInterval2:rect2Y]) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 弧度&角度
- (float)getRadFromDeg: (float) deg {
    float rad = (M_PI / 180) * deg;
    return rad;
}

- (float)getDegFromRad: (float) rad {
    float deg = (180 / M_PI) * rad;
    return deg;
}

#pragma mark - 随机数
+ (int)getRandBetween:(int)bottom and:(int)top
{
    // 取模 -> [bottom, top]
    int rand = bottom + (arc4random()% (top-bottom+1));
    return rand;
}

#pragma mark - Support
+ (struct KMMathInterval_RationalNumber)projectRect:(CGRect)rect toAxis:(KMAxisType)axisType
{
    /**
     *  采用了自定义左右端点来标识区间，根据数轴正方向为右，需要保证left<=right
     */
    
    CGPoint rectDiag = CGPointMake(rect.origin.x+rect.size.width,
                                    rect.origin.y+rect.size.height);
    CGPoint rectOrigin = rect.origin;
    
    switch (axisType) {
        case X: {
            CGFloat x1 = rectOrigin.x;
            CGFloat x2 = rectDiag.x;
            
            // 需要保证生成的区间左端点left小于右端点right
            if (x1>x2) {
                CGFloat tmp = 0;
                tmp = x1;
                x1 = x2;
                x2 = tmp;
            }
            
            struct KMMathInterval_RationalNumber interval = {x1, x2};
            return interval;
            
            break;
        }
            
        case Y: {
            CGFloat y1 = rectOrigin.y;
            CGFloat y2 = rectDiag.y;
            
            // 需要保证生成的区间左端点left小于右端点right
            if (y1>y2) {
                CGFloat tmp = 0;
                tmp = y1;
                y1 = y2;
                y2 = tmp;
            }

            struct KMMathInterval_RationalNumber interval = {y1, y2};
            return interval;
            
            break;
        }

        case Z: {
            struct KMMathInterval_RationalNumber interval = {0, 0};
            return interval;
            
            break;
        }

        default: {
            struct KMMathInterval_RationalNumber interval = {0, 0};
            return interval;
            
            break;
        }
    }
}

+ (BOOL)checkInterval1:(struct KMMathInterval_RationalNumber)interval1
  overlayWithInterval2:(struct KMMathInterval_RationalNumber)interval2
{
    /**
     *  端点处的重叠，不归为区间的重叠
     */
    
    // interval1
    CGFloat left1 = interval1.left;
    CGFloat right1 = interval1.right;
    
    // interval2
    CGFloat left2 = interval2.left;
    CGFloat right2 = interval2.right;
    
    // Which is more leftward
    CGFloat left = 0;
    CGFloat right = 0;
    
    if (left1 < left2) {
        right = right1;
        left = left2;
    }
    else {
        right = right2;
        left = left1;
    }
    
    if (right > left) {
        return YES;
    }
    
    return NO;
}



@end
