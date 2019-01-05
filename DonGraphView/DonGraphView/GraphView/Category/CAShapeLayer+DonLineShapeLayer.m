//
//  CAShapeLayer+DonLineShapeLayer.m
//  DonGraphView
//
//  Created by LingPin on 2019/1/5.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

#import "CAShapeLayer+DonLineShapeLayer.h"

@implementation CAShapeLayer (DonLineShapeLayer)

+ (CAShapeLayer *)don_getShapeLayer {
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    
    return layer;
}

+ (CAShapeLayer *)don_getShapeLayerWithBezierPath:(UIBezierPath *)path {
    CAShapeLayer *layer = [self don_getShapeLayer];
    layer.path = path.CGPath;
    return layer;
}

+ (CAShapeLayer *)don_getRectangleLayerWithFrame:(CGRect)frame
                                       lineWidth:(CGFloat)lineWidth
                                     strokeColor:(UIColor *)strokeColor
                                       fillColor:(UIColor *)fillColor {
    
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
    CAShapeLayer *layer = [self don_getShapeLayer];
    layer.path = path.CGPath;
    layer.lineWidth = 1.0f;
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor = fillColor.CGColor;
    return layer;
}

+ (CAShapeLayer *)don_getHollowRectangleLayerWithFrame:(CGRect)frame
                                             lineWidth:(CGFloat)lineWidth
                                           strokeColor:(UIColor *)strokeColor {
    return [self don_getRectangleLayerWithFrame:frame lineWidth:lineWidth strokeColor:strokeColor fillColor:[UIColor clearColor]];
}

+ (CAShapeLayer *)don_getSolidRectangleLayerWithFrame:(CGRect)frame
                                             lineWidth:(CGFloat)lineWidth
                                           fillColor:(UIColor *)fillColor {
    return [self don_getRectangleLayerWithFrame:frame lineWidth:lineWidth strokeColor:fillColor fillColor:fillColor];
}

+ (CAShapeLayer *)don_getLinesLayerWithPointss:(NSArray <NSValue *>*)pointss
                                    lineWidth:(CGFloat)lineWidth
                                  strokeColor:(UIColor *)strokeColor {
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [pointss enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx) {
            [path addLineToPoint:[obj CGPointValue]];
        } else {
            [path moveToPoint:[obj CGPointValue]];
        }
    }];
    
    CAShapeLayer *layer = [self don_getShapeLayerWithBezierPath:path];
    layer.lineWidth = lineWidth;
    layer.strokeColor = strokeColor.CGColor;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.path = path.CGPath;
    return layer;
}

@end
