//
//  DonGraphPointModel.swift
//  Test_GraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

import UIKit

class DonGraphPointModel: NSObject {
    open var dateStr:NSString = "";
    open var valueArray = [NSNumber]();
    static func getMaxAndMin(dataArray:[DonGraphPointModel],boundaryValue:(_ max:CGFloat,_ min:CGFloat)->()){
        var maxValue:Double = 0.0;
        var minValue:Double = 0.0;
        let myModel:DonGraphPointModel = dataArray[0];
        maxValue = myModel.valueArray.first?.doubleValue ?? 0;
        minValue = myModel.valueArray.first?.doubleValue ?? 0;
        for model:DonGraphPointModel in dataArray {
            for number:NSNumber in model.valueArray{
                if minValue > number.doubleValue{
                    minValue = number.doubleValue;
                }
                if maxValue < number.doubleValue{
                    maxValue = number.doubleValue;
                }
            }
        }
        boundaryValue(CGFloat(maxValue),CGFloat(minValue));
    }
    static func getBarViewMaxAndMin(dataArray:[DonGraphPointModel],boundaryValue:(_ max:CGFloat,_ min:CGFloat)->()){
        var maxValue:Double = 0.0;
        var minValue:Double = 0.0;
        let myModel:DonGraphPointModel = dataArray[0];
        maxValue = myModel.valueArray.first?.doubleValue ?? 0;
        minValue = myModel.valueArray.first?.doubleValue ?? 0;
        NSLog("%ld", dataArray.count);
        for model:DonGraphPointModel in dataArray {
            
            if minValue > model.valueArray.first?.doubleValue ?? 0{
                minValue = model.valueArray.first?.doubleValue ?? 0;
            }
        }
        boundaryValue(CGFloat(maxValue),CGFloat(minValue));
    }
}
