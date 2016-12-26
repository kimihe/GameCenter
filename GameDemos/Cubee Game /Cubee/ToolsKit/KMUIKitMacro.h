//
//  KMUIKitMacro.h
//  KMNineBoxDemo
//
//  Created by 周祺华 on 2016/10/28.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#ifndef KMUIKitMacro_h
#define KMUIKitMacro_h

//获取屏幕 宽度、高度
#define kSCREEN_WIDTH          ([UIScreen mainScreen].bounds.size.width)             //!< UIScreen宽度
#define kSCREEN_HEIGHT         ([UIScreen mainScreen].bounds.size.height)            //!< UIScreen高度

//16进制表示RGBA
#define colorFromRGBA(rgbValue,trans) [UIColor \
                colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
                         green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
                         blue:((float)(rgbValue & 0xFF))/255.0 alpha:trans]


#endif /* KMUIKitMacro_h */
