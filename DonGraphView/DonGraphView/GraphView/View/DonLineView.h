//
//  DonLineView.h
//  Test_TableView
//
//  Created by hongchao.li on 2018/9/21.
//  Copyright © 2018年 DonWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DonGraphPointModel.h"
@interface DonLineView : UIView
@property (nonatomic, assign)CGFloat aAxisInstance;
@property (nonatomic, assign)CGFloat verticalMaxValue;
@property (nonatomic, assign)CGFloat verticalMinValue;



@property (nonatomic, copy)NSArray <DonGraphPointModel *>*pointArray;
//绘图的总高度
@property (nonatomic, assign)CGFloat maxHeight;
@property (nonatomic, copy)NSString *dateFormatStyle;

//数据分级范围
@property (nonatomic, strong)NSArray <NSArray <NSString *>*>*standardValues;
//颜色
@property (nonatomic, strong)NSArray <NSArray <UIColor *>*>*colors;

@property (nonatomic, strong)NSArray <UIColor * >*lineColors;
- (void)begainDraw;
@end
