//
//  DonGraphPointModel.h
//  DonGraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface DonGraphPointModel : NSObject
@property (nonatomic, copy)NSString *dateStr;
//  柱状图  入量 夜尿量  白天尿量
@property (nonatomic, strong)NSArray <NSNumber *>*valueArray;

+ (void)getMaxAndMin:(NSArray <DonGraphPointModel *>*)dataAarray value:(void(^)(CGFloat max,CGFloat min))boundaryValue;

+ (void)getBarViewMaxAndMin:(NSArray <DonGraphPointModel *>*)dataAarray value:(void(^)(CGFloat max,CGFloat min))boundaryValue;
@end

NS_ASSUME_NONNULL_END
