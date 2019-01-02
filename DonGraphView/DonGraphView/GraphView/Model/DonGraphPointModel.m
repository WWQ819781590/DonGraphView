//
//  DonGraphPointModel.m
//  DonGraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

#import "DonGraphPointModel.h"

@implementation DonGraphPointModel
+ (void)getMaxAndMin:(NSArray <DonGraphPointModel *>*)dataAarray value:(void(^)(CGFloat max,CGFloat min))boundaryValue{
    CGFloat maxValue = 0;
    CGFloat minValue = 0;
    for (int i = 0; i<dataAarray.count; i++) {
        
        DonGraphPointModel *model = dataAarray[i];
        if (i == 0) {
            maxValue = [model.valueArray.firstObject floatValue];
            minValue = [model.valueArray.firstObject floatValue];
        }
        for (int num = 0; num < model.valueArray.count; num ++) {
            NSNumber *number = model.valueArray[num];
            if (minValue > number.floatValue) {
                minValue = number.floatValue;
            }
            if (maxValue < number.floatValue) {
                maxValue = number.floatValue;
            }
        }
    }
    boundaryValue(maxValue,minValue);
}

+ (void)getBarViewMaxAndMin:(NSArray <DonGraphPointModel *>*)dataAarray value:(void(^)(CGFloat max,CGFloat min))boundaryValue{
    CGFloat maxValue = 0;
    CGFloat minValue = 0;
    for (int i = 0; i<dataAarray.count; i++) {
        
        DonGraphPointModel *model = dataAarray[i];
        NSAssert(model.valueArray.count == 3, @"出入量柱状图数据应是三条");
        if (i == 0) {
            maxValue = [model.valueArray.firstObject floatValue];
            minValue = [model.valueArray.firstObject floatValue];
        }
        if (minValue > model.valueArray.firstObject.floatValue) {
            minValue = model.valueArray.firstObject.floatValue;
        }
        
        if (maxValue < model.valueArray.firstObject.floatValue) {
            maxValue = model.valueArray.firstObject.floatValue;
        }
        if (minValue > [model.valueArray[1] floatValue]+[model.valueArray[2] floatValue]) {
            minValue = [model.valueArray[1] floatValue] + [model.valueArray[2] floatValue];;
        }
        if (maxValue < [model.valueArray[1] floatValue]+[model.valueArray[2] floatValue]) {
            maxValue = [model.valueArray[1] floatValue] + [model.valueArray[2] floatValue];;
        }
        
    }
    boundaryValue(maxValue,minValue);
    
}
@end
