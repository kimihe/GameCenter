//
//  KMDropView.m
//  Cubee
//
//  Created by 周祺华 on 2016/11/25.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "KMDropView.h"
#import "KMUIKitMacro.h"

@implementation KMDropView
{
    CGFloat _selfBoundsX;
    CGFloat _selfBoundsY;
    
    CGFloat _selfFrameX;
    CGFloat _selfFrameY;
    CGFloat _selfFrameWidth;
    CGFloat _selfFrameHeight;
    CGFloat _selfFrameSquareWidth;          //!< 如果frame不是正方形，则取短边构造内置正方形
}

#pragma mark - Init & Setup
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    return self;
    
}

- (void)initData
{
    _borderColor = [UIColor blackColor];
    _insideSqureColor = [UIColor whiteColor];
    _pattern = nil;
    _type = @"#$%^&*";
    
    [self setupBoundsAndFrame];
}

- (void)setupBoundsAndFrame
{
    _selfBoundsX      = self.bounds.origin.x;
    _selfBoundsY      = self.bounds.origin.y;
    
    _selfFrameX       = self.frame.origin.x;
    _selfFrameY       = self.frame.origin.y;
    _selfFrameWidth   = self.frame.size.width;
    _selfFrameHeight  = self.frame.size.height;
    _selfFrameSquareWidth = (_selfFrameWidth<=_selfFrameHeight)? _selfFrameWidth : _selfFrameHeight;
}

#pragma mark - layoutSubviews
- (void)layoutSubviews {
    [self setupBoundsAndFrame];
}

#pragma mark - Property Set Methods
- (void)setBorderColor:(UIColor *)borderColor
{
    _borderColor = borderColor;
}

- (void)setInsideSqureColor:(UIColor *)insideSqureColor
{
    _insideSqureColor = insideSqureColor;
}

- (void)setPattern:(UIImage *)pattern
{
    _pattern = pattern;
}

- (void)setState:(KMDropViewState)state
{
    _state = state;
    
    // 重绘前消除一切sublayer
    if ([self.layer.sublayers count] > 0) {
        self.layer.sublayers = nil;
    }

    switch (state) {
        case KMDropViewStateNormal: {
            
            [self setupBorderColor:_borderColor lineWidth:1.0f];
            [self setupInsideSqureColor:_insideSqureColor lineWidth:1.0f];
            [self setupPattern:_pattern];
            break;
        }
            
        case KMDropViewStateHighlight: {
            
            [self setupBorderColor:colorFromRGBA(0x89CFF0, 1.0) lineWidth:3.0f];
            [self setupInsideSqureColor:_insideSqureColor lineWidth:1.0f];
            [self setupPattern:_pattern];
            break;
        }
            
        default:
            break;
    }
}

- (void)setType:(NSString *)type
{
    _type = [type copy];
}

#pragma mark - Support Methods
- (void)setupBorderColor:(UIColor *)color lineWidth:(CGFloat)width
{
    if ([color isEqual:[UIColor clearColor]]) {
        return;
    }
    if (width <= 0.0) {
        return;
    }
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(_selfBoundsX, _selfBoundsY)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX+_selfFrameSquareWidth, _selfBoundsY)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX+_selfFrameSquareWidth, _selfBoundsY+_selfFrameSquareWidth)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX, _selfBoundsY+_selfFrameSquareWidth)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX, _selfBoundsY)];
    
    
    //draw the path using a CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = width;
    
    [self.layer addSublayer:shapeLayer];
}

- (void)setupInsideSqureColor:(UIColor *)color lineWidth:(CGFloat)width
{
    if ([color isEqual:[UIColor clearColor]]) {
        return;
    }
    if (width <= 0.0) {
        return;
    }
    
    CGFloat ratio = 0.8;
    CGFloat margin = _selfFrameSquareWidth*(1-ratio)/2;
    CGFloat insideSqureWidth = _selfFrameSquareWidth*ratio;
    
    //create a path
    UIBezierPath *bezierPath = [[UIBezierPath alloc] init];
    [bezierPath moveToPoint:CGPointMake(_selfBoundsX+margin, _selfBoundsY+margin)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX+margin+insideSqureWidth, _selfBoundsY+margin)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX+margin+insideSqureWidth, _selfBoundsY+margin+insideSqureWidth)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX+margin, _selfBoundsY+margin+insideSqureWidth)];
    [bezierPath addLineToPoint:CGPointMake(_selfBoundsX+margin, _selfBoundsY+margin)];
    
    
    //draw the path using a CAShapeLayer
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = color.CGColor;
    shapeLayer.strokeColor = color.CGColor;
    shapeLayer.lineWidth = width;
    
    [self.layer addSublayer:shapeLayer];
}

- (void)setupPattern:(UIImage *)pattern
{
    if (!pattern) {
        return;
    }
    
    self.contentMode = UIViewContentModeScaleAspectFill;
    self.layer.contents = (__bridge id _Nullable)(pattern.CGImage);
}

#pragma mark - <NSCopying>
- (id)copyWithZone:(nullable NSZone *)zone
{
    KMDropView *copy = [[[self class] alloc] initWithFrame:self.frame];
    
    copy.borderColor = _borderColor;
    copy.insideSqureColor = _insideSqureColor;
    copy.pattern  = _pattern;
    copy.state = _state;
    
    copy.type = _type;
    
    return copy;
}

#pragma mark - Duplicate (KMDropView *)
+ (KMDropView *)duplicateFrom:(KMDropView *)originView
{
    KMDropView *duplicatedView = [[KMDropView alloc] initWithFrame:originView.frame];
    
    duplicatedView.borderColor = originView.borderColor;
    duplicatedView.insideSqureColor = originView.insideSqureColor;
    duplicatedView.pattern  = originView.pattern;
    duplicatedView.state = originView.state;
    
    duplicatedView.type = originView.type;
    
    return duplicatedView;
}

#pragma mark - Description
- (NSString *)description
{
    NSString *description = [NSString stringWithFormat:@"<%@: %p> : %@",
                             [self class],
                             self,
                             @{@"borderColor" : (_borderColor) ? _borderColor : @"NULL",
                               @"insideSqureColor" : (_insideSqureColor) ? _insideSqureColor : @"NULL",
                               @"pattern" : (_pattern) ? _pattern : @"NULL",
                               @"state" : ([NSNumber numberWithUnsignedInteger:_state]) ? [NSNumber numberWithUnsignedInteger:_state] : @"NULL" ,
                               @"type" : (_type)? _type : @"NULL"
                               }];
    return description;
}

@end
