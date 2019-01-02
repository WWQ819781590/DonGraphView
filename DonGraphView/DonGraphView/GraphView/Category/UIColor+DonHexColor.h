//
//  UIColor+DonHexColor.h
//  DonGraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (DonHexColor)
+ (UIColor *)colorWithHexColor:(NSString *)colorString;
+ (UIColor *)colorWithHexColor:(NSString *)colorString alpha:(CGFloat)alpha;
@end

NS_ASSUME_NONNULL_END
