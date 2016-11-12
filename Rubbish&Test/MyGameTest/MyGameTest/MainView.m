//
//  MainView.m
//  MyGameTest
//
//  Created by 周祺华 on 2016/11/11.
//  Copyright © 2016年 周祺华. All rights reserved.
//

#import "MainView.h"

int W=320;
int H=480;

@implementation MainView

- (void) drawRect: (CGRect) rect {
    W = rect.size.width;
    H = rect.size.height;
    NSLog(@"W: %i H: %i", W, H);
    
    CGContextRef gc = UIGraphicsGetCurrentContext();
    
    
    
    // String
    NSString *str = @"My Game";
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    style.alignment = NSTextAlignmentCenter;
    NSDictionary *attributesDic = @{
                                    NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Thin" size:50.0],
                                    NSParagraphStyleAttributeName : style,
                                    NSForegroundColorAttributeName : [UIColor colorWithRed:1.0 green:0.0 blue:0 alpha:1.0]
                                    };
    [str drawInRect:CGRectMake(rect.origin.x, rect.origin.y+20, rect.size.width, rect.size.height) withAttributes:attributesDic];
    
    
    // Three Lines make a triangle
    CGContextSetLineWidth(gc, 3.0);
    CGContextMoveToPoint(gc, W/2, 0);
    CGContextAddLineToPoint(gc, 0, H/2);
    CGContextAddLineToPoint(gc, W, H/2);
    CGContextAddLineToPoint(gc, W/2, 0);
    CGContextSetRGBStrokeColor(gc, 0, 1, 0, 1);//green
    CGContextStrokePath(gc);
    
    
    
    // Random Lines
    CGContextMoveToPoint(gc, W/2, H/2);
    for (int i = 0; i < 10; i++) {
        int x = [self getRndBetween:0 and:W];
        int y = [self getRndBetween:0 and:H];
        CGContextAddLineToPoint(gc, x, y);
    }
    CGContextSetRGBStrokeColor(gc, 0, 0, 1, 1);//blue
    CGContextStrokePath(gc);
    
    
    
    
    // Rectangle
    CGRect rectangle = CGRectMake(100, 100, 50, 50);
    CGContextAddRect(gc, rectangle);
    CGContextSetRGBFillColor(gc, 1, 1, 1, 1);// white
    CGContextDrawPath(gc, kCGPathFillStroke);
    
    
    
    
    // Ellipse & Circle
    [self drawCircle:200 y:300 radius:50 gc:gc];
    
    
    
    
    
    @try {
        
        UIImage *carBlueImage = [UIImage imageNamed: @"car_blue.png"];
        [carBlueImage drawAtPoint: CGPointMake(140, 140)];
        
        UIImage *carRedImage = [UIImage imageNamed: @"car_red.png"];
        UIImage *carGreenImage = [UIImage imageNamed: @"car_green.png"];
        for (int i=0; i<10; i++) {
            int x, y;
            x = [self getRndBetween: 0 and: W];
            y = [self getRndBetween: 0 and: H];
            [carBlueImage drawAtPoint: CGPointMake(x, y)];
            x = [self getRndBetween: 0 and: W];
            y = [self getRndBetween: 0 and: H];
            [carRedImage drawAtPoint: CGPointMake(x, y)];
            x = [self getRndBetween: 0 and: W];
            y = [self getRndBetween: 0 and: H];
            [carGreenImage drawAtPoint: CGPointMake(x, y)];
        }
        
        int picW = carBlueImage.size.width;
        int picH = carBlueImage.size.height;
        NSLog(@"Size of pic: %ix%i", picW, picH);
        
        [carBlueImage drawInRect: CGRectMake(120, 250, picW*2, picH*2)];

        [carBlueImage drawAtPoint: CGPointMake(40, 140)
                        blendMode: kCGBlendModeNormal
                            alpha: 0.4];
        [carBlueImage drawAtPoint: CGPointMake(25, 125)
                        blendMode: kCGBlendModeNormal
                            alpha: 0.4];

        for (int i=0; i<20; i++) {
            [self rotateImage: @"car_green.png"
                            x: [self getRndBetween: 0 and: W]
                            y: [self getRndBetween: 0 and: W]
                        angle: [self getRndBetween: 0 and: 360]];
        }
        
    }
    @catch (id theException) {
        NSLog(@"ERROR: Pic(s) not found.");
    }
}

- (int)getRndBetween:(int)bottom and:(int)top
{
    // 取模 -> [bottom, top]
    int rand = bottom + (arc4random()% (top-bottom+1));
    return rand;
}

- (void)drawCircle:(int)x y:(int)y radius:(int)radius gc:(CGContextRef)gc
{
    CGRect rect = CGRectMake(x-radius, y-radius, 2*radius, 2*radius);
    CGContextAddEllipseInRect(gc, rect);
    CGContextSetRGBFillColor(gc, 0, 0, 0, 0);// clearColor
    CGContextSetRGBStrokeColor(gc, 0, 1, 0, 1); // green
    CGContextDrawPath(gc, kCGPathFillStroke);
}

- (void) rotateImage: (NSString*) picName
                   x: (int) x
                   y: (int) y
               angle: (int) a {
    
    UIImage *pic = [UIImage imageNamed: picName];
    
    if (pic) {
        int w = pic.size.width;
        int h = pic.size.height;
        
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        CGContextSaveGState(ctx);
        
        CGContextTranslateCTM(ctx, x+w/2, y+h/2);
        
        CGContextRotateCTM(ctx, [self getRad: a]);
        
        [pic drawAtPoint: CGPointMake(0-w/2, 0-h/2)];
        
        CGContextRestoreGState(ctx); 
    } 
}

- (float) getRad: (float) grad {
    float rad = (M_PI / 180) * grad;
    return rad;
}

- (float) getGrad: (float) rad {
    float grad = (180 / M_PI) * rad;
    return grad;
}



@end
