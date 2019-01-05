//
//  CAShapeLayer+DonLineShapeLayer.h
//  DonGraphView
//
//  Created by LingPin on 2019/1/5.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAShapeLayer (DonLineShapeLayer)

/**
 获取CAShapeLayer

 @return CAShapeLayer
 */
+ (CAShapeLayer *)don_getShapeLayer;

/**
 根据路径获取CAShapeLayer

 @param path 路径
 @return CAShapeLayer
 */
+ (CAShapeLayer *)don_getShapeLayerWithBezierPath:(UIBezierPath *)path;

/**
 获取矩形的CAShapeLayer

 @param frame 位置
 @param lineWidth 线条宽度
 @param strokeColor 线条颜色
 @param fillColor 填充颜色
 @return CAShapeLayer
 */
+ (CAShapeLayer *)don_getRectangleLayerWithFrame:(CGRect)frame
                                       lineWidth:(CGFloat)lineWidth
                                     strokeColor:(UIColor *)strokeColor
                                       fillColor:(UIColor *)fillColor;

/**
 获取空心矩形的CAShapeLayer

 @param frame 位置
 @param lineWidth 线条宽度
 @param strokeColor 线条颜色
 @return CAShapeLayer
 */
+ (CAShapeLayer *)don_getHollowRectangleLayerWithFrame:(CGRect)frame
                                             lineWidth:(CGFloat)lineWidth
                                           strokeColor:(UIColor *)strokeColor;

/**
 获取实心矩形的CAShapeLayer

 @param frame 坐标
 @param lineWidth 线条宽度
 @param fillColor 填充颜色
 @return CAShapeLayer
 */
+ (CAShapeLayer *)don_getSolidRectangleLayerWithFrame:(CGRect)frame
                                            lineWidth:(CGFloat)lineWidth
                                            fillColor:(UIColor *)fillColor;

/**
 获取一段线条的CAShapeLayer

 @param pointss 坐标
 @param lineWidth 线条宽度
 @param strokeColor 线条颜色
 @return CAShapeLayer
 */
+ (CAShapeLayer *)don_getLinesLayerWithPointss:(NSArray <NSValue *>*)pointss
                                     lineWidth:(CGFloat)lineWidth
                                   strokeColor:(UIColor *)strokeColor;

@end

NS_ASSUME_NONNULL_END
