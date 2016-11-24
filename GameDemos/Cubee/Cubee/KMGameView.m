//
//  KMGameView.m
//  Cubee
//
//  Created by 周祺华 on 2016/11/24.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "KMGameView.h"


NSInteger dropsPerRow = 10;
CGSize DROP_SIZE = {50, 50};

@implementation KMGameView


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setupBoundsAndFrame];
    }
    return self;

}

- (void)initData
{
    self.backgroundColor = [UIColor grayColor];
}

- (void)setupBoundsAndFrame
{
    dropsPerRow = 10;
    DROP_SIZE  = CGSizeMake(self.frame.size.width/dropsPerRow, self.frame.size.width/dropsPerRow);
}

@end
