//
//  KMMathHelper.h
//  BezierCurve_Test
//
//  Created by nali on 16/8/20.
//  Copyright © 2016年 Kimi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  右手系X-Y-Z
 */
typedef NS_ENUM(NSUInteger, KMAxisType) {
    /**
     *  <#Description#>
     */
    X = 0,
    /**
     *  <#Description#>
     */
    Y = 1,
    /**
     *  <#Description#>
     */
    Z = 2,
};

/**
 *  有理数闭区间，通用区间待扩充
 */
struct KMMathInterval_RationalNumber {
    CGFloat left;
    CGFloat right;
};

@interface KMMathHelper : NSObject

#pragma mark - 二维空间直角坐标系
/**
 *  求二维空间两点的中点
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 中点
 */
+ (CGPoint)getMiddleFromPoint1:(CGPoint)point1 point2:(CGPoint)point2;


/**
 *  求二维空间两点的几何距离
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 距离
 */
+ (double)getDistanceBetweenPoint1:(CGPoint)point1 point2:(CGPoint)point2;


/**
 *  根据位移和方向角求新的点
 *
 *  @param currentPoint 当前点
 *  @param offset       位移(位移为负时其实为反方向)
 *  @param angle        方向角
 *
 *  @return 新的点
 */
+ (CGPoint)getNewPointFromCurrentPoint:(CGPoint)currentPoint offset:(double)offset angle:(double)angle;


/**
 *  已知直线上起点和终点，根据位移比例求运动点
 *
 *  @param startPoint 起点
 *  @param endPoint   终点
 *  @param rate       比例
 *
 *  @return 运动点
 */
+ (CGPoint)getNewPointFromStartPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint rate:(double)rate;


/**
 *  求两点的斜率亦梯度
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 斜率(以点1->点2为正方向)，可能会因斜率无限大返回NAN，NAN请用isnan(k)来判断
 */
+(double)getGradientFromPoint1:(CGPoint)point1 point2:(CGPoint)point2;


/**
 *  判断两个CGPoint是否相同
 *
 *  @param point1 点1
 *  @param point2 点2
 *
 *  @return 相同返回YES，不同返回NO
 */
+ (BOOL)point1:(CGPoint)point1 EqualToPoint2:(CGPoint)point2;

/**
 *  直接比较：判断两点间距离是否小于某值，某值使用真实的距离。判断时会比较距离的平方，建议使用平方比较。
 *
 *  @param p1 点1
 *  @param p2 点1
 *  @param d  真实的距离
 *
 *  @return 小于返回YES，大于等于返回NO
 */
+ (BOOL)checkDistanceBetween:(CGPoint)p1 and:(CGPoint)p2 lessThan:(CGFloat)d;


/**
 *  平方比较：判断两点间距离是否小于某值，某值使用距离的平方。判断时会直接比较这个平方，可提高计算效率。
 *
 *  @param p1 点1
 *  @param p2 点1
 *  @param squre  距离的平方
 *
 *  @return 小于返回YES，大于等于返回NO
 */
+ (BOOL)checkDistanceBetween:(CGPoint)p1 and:(CGPoint)p2 lessThanSqure:(CGFloat)squre;


/**
 *  判断二维平面直角坐标系下，两个矩形区域是否有重叠部分
 *
 *  @param rect1 矩形区域1
 *  @param rect2 矩形区域2
 *
 *  @return 有重叠返回YES，无重叠返回NO
 */
+ (BOOL)checkRect1:(CGRect)rect1 overlayWithRect2:(CGRect)rect2;


# pragma mark - 弧度&角度
/**
 *  角度转弧度
 *
 *  @param deg 角度(degree)
 *
 *  @return 弧度(radian)
 */
- (float)getRadFromDeg: (float) deg;


/**
 *  弧度转角度
 *
 *  @param rad 弧度(radian)
 *
 *  @return 角度(degree)
 */
- (float)getDegFromRad: (float) rad;



# pragma mark- 随机数
/**
 *  在闭区间内取随机数
 *
 *  @param bottom 左端点
 *  @param top    右端点
 *
 *  @return 返回随机数
 */
+ (int)getRandBetween:(int)bottom and:(int)top;

@end
