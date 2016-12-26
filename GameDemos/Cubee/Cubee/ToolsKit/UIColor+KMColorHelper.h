//
//  UIColor+KMColorHelper.h
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (KMColorHelper)
/**
 *  返回随机颜色
 *
 *  @return 0x000000 - 0xFFFFFF间随机
 */
+ (UIColor *)randomColor;


/**
 *  在红绿两色间随机返回
 *
 *  @return 返回的颜色
 */


+ (UIColor *)randomTwoColor;;

/**
 *  在红绿蓝三种颜色中随机返回
 *
 *  @return 返回的颜色
 */
+ (UIColor *)randomThreeColor;


/**
 *  在五种常见的颜色中随机选取(红，绿，蓝，黄，紫)
 *
 *  @return 返回的颜色
 */
+ (UIColor *)randomFiveColor;

@end
