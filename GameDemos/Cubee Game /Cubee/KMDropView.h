//
//  KMDropView.h
//  Cubee
//
//  Created by 周祺华 on 2016/11/25.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, KMDropViewState) {
    KMDropViewStateNormal = 1<<0,
    KMDropViewStateHighlight = 1<<1
};

@interface KMDropView : UIView

@property(strong, nonatomic)UIColor *borderColor;       //!< dropView边框的颜色

@property(strong, nonatomic)UIColor *insideSqureColor;  //!< 内部填充的颜色

@property(strong, nonatomic)UIImage *pattern;           //!< 内部的图案

@property(assign, nonatomic)KMDropViewState state;      //!< 根据状态枚举，设置样式效果，注意：效果取决于上述三个property

/**
 *  通过字符串标识不类型同的dropView，比如用户可以绘制石头，剪刀，布三种类型的dropView
 *  注意type的copy语义。
 */
@property(nonatomic, copy)NSString *type;


/**
 返回 <class: self address> : {borderColor, insideSqureColor, pattern, state, type}
 
 */
@property (nonatomic, readonly, strong) NSString *description;


- (instancetype)initWithFrame:(CGRect)frame;


/**
 *  深拷贝一个KMDropView
 *
 *  @param originView 源本
 *
 *  @return 返回深拷贝的副本
 */
+ (KMDropView *)duplicateFrom:(KMDropView *)originView;

@end
