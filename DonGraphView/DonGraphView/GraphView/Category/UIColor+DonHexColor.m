//
//  UIColor+DonHexColor.m
//  DonGraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

#import "UIColor+DonHexColor.h"

@implementation UIColor (DonHexColor)
+ (UIColor *)colorWithHexColor:(NSString *)colorString{
    return [self colorWithHexColor:colorString alpha:1.0];
}
+ (UIColor *)colorWithHexColor:(NSString *)colorString alpha:(CGFloat)alpha{
    UIColor *color = [UIColor whiteColor];
    if (colorString.length < 6) {
        return color;
    }
    NSString *tempString = colorString;
    //    [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
    if ([colorString hasPrefix:@"#"]) {
        tempString = [colorString substringFromIndex:1];
    }
    if ([colorString hasPrefix:@"0*"]) {
        tempString = [colorString substringFromIndex:2];
    }
    if (tempString.length != 6) {
        return color;
    }
    
    
    NSInteger length = 2;
    NSInteger rLocation = 0;
    
    NSRange range = NSMakeRange(rLocation, length);
    NSString *rString = [tempString substringWithRange:range];
    range.location = 2+rLocation;
    NSString *gString = [tempString substringWithRange:range];
    range.location = 4+rLocation;
    NSString *bString = [tempString substringWithRange:range];
    //取三种颜色值
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    color = [UIColor colorWithRed:((float)r /255.f) green:((float)g /255.f) blue:((float)b /255.f) alpha:alpha];
    return color;
}
@end
