//
//  KMGameView.h
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KMGameView : UIView

extern NSInteger dropsPerRow;
extern CGSize DROP_SIZE;

- (instancetype)initWithFrame:(CGRect)frame;
@end
