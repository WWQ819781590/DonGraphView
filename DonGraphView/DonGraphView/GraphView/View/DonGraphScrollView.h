//
//  DonGraphScrollView.h
//  Test_TableView
//
//  Created by hongchao.li on 2018/9/21.
//  Copyright © 2018年 DonWang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DonGraphPointModel;
typedef NS_ENUM (NSInteger,GraphViewStyle){
    GraphViewStyleLine = 0,
    GraphViewStyleBar
};
@interface DonGraphScrollView : UIView
//文字颜色
@property (nonatomic, copy)UIColor *textColor;
//折线相关    标注点的颜色
@property (nonatomic, copy)UIColor *normalViewColor;
@property (nonatomic, copy)UIColor *abnormalViewColor;
//解决底部横纵轴不对齐的问题
@property (nonatomic, copy)NSString *from;

//数据分级范围
@property (nonatomic, strong)NSArray <NSArray <NSString *>*>*standardValues;
//点颜色
@property (nonatomic, strong)NSArray <NSArray <UIColor *>*>*colors;
//折线颜色
@property (nonatomic, strong)NSArray <UIColor * >*lineColors;
@property (nonatomic, copy)UIColor *lineColor;
//柱状图

#pragma mark  ======   数据相关
//底部视图
@property (nonatomic, strong)UIView *bottomView;
//顶部视图
@property (nonatomic, strong)UIView *topView;
//单位
@property (nonatomic, copy)NSString *unitString;
//正常范围最大值
@property (nonatomic, copy)NSString *normalValue_MaxStr;
//正常范围最小值
@property (nonatomic, copy)NSString *normalValue_MinStr;
@property (nonatomic, assign)GraphViewStyle viewStyle;
//横轴时间的显示格式
@property (nonatomic, copy)NSString *dateFormatStyle;

- (void)begainGraphWith:(NSArray <DonGraphPointModel *>*)dataArray;
- (void)drawDottedLineWith:(CGFloat)numberValue colorWith:(UIColor *)color;
@end
