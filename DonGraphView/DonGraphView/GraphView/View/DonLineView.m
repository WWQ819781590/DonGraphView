//
//  DonLineView.m
//  Test_TableView
//
//  Created by hongchao.li on 2018/9/21.
//  Copyright © 2018年 DonWang. All rights reserved.
//

#import "DonLineView.h"
#import <Masonry/Masonry.h>
#import "UIColor+DonHexColor.h"
@interface DonLineView()
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)NSArray *dateLabelArray;
@property (nonatomic, strong)NSArray *viewArray;
@property (nonatomic, strong)NSArray *valueArray;

@end
@implementation DonLineView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    UIView *lineView = [[UIView alloc]init];
    [self addSubview:lineView];
    _lineView = lineView;
    lineView.backgroundColor = [UIColor colorWithHexColor:@"979797"];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.left.equalTo(self).offset(-1.f);
        make.top.equalTo(self).offset(0.f);
        make.height.mas_equalTo(1.f);
    }];
}
-(void)setMaxHeight:(CGFloat)maxHeight{
    _maxHeight = maxHeight;
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(maxHeight);
    }];
}
- (void)begainDraw{
    NSLog(@"%@",NSStringFromCGRect(self.frame));
    DonGraphPointModel *model = self.pointArray.firstObject;
    for (int i = 0; i<model.valueArray.count; i++) {
        [self drawGraphViewWith:i];
    }
}




- (void)drawGraphViewWith:(NSInteger )index{
    self.maxHeight = self.maxHeight > 0 ? self.maxHeight : 200.f;
    UIGraphicsBeginImageContext(self.bounds.size);
    UIBezierPath *path = [UIBezierPath bezierPath];
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.lineWidth = 2.f;
    layer.fillColor = [UIColor clearColor].CGColor;
    layer.strokeColor = [[self lineColorWith:index] CGColor];
    [self.layer addSublayer:layer];
    [self.pointArray enumerateObjectsUsingBlock:^(DonGraphPointModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat x = idx * self.aAxisInstance + self.aAxisInstance/2.f;
        CGFloat y = (self.verticalMaxValue - [obj.valueArray[index] floatValue])/(self.verticalMaxValue - self.verticalMinValue)*self.maxHeight;
        CGPoint point = CGPointMake(x, y);
        if(idx == 0){
            [path moveToPoint:point];
        }else{
            [path addLineToPoint:point];
        }
        UIView *pointView = [[UIView alloc]init];
        [self addSubview:pointView];
        pointView.layer.cornerRadius = 8.f;
        pointView.backgroundColor = [self pointColorWith:index value:[obj.valueArray[index] floatValue]];
        
        pointView.bounds = CGRectMake(0, 0, 16.f, 16.f);
        pointView.center = point;
        UILabel *valueLabel = [[UILabel alloc]init];
        [self addSubview:valueLabel];
        valueLabel.text = [NSString stringWithFormat:@"%.1f",[obj.valueArray[index] floatValue]];
        valueLabel.font = [UIFont systemFontOfSize:14.f];
        valueLabel.textColor = [UIColor colorWithHexColor:@"333333"];
        [valueLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(pointView);
            make.bottom.equalTo(pointView.mas_top).offset(-2.f);
        }];
        if (index == 0) {
            UILabel *dateLabel = [[UILabel alloc]init];
            [self addSubview:dateLabel];
            dateLabel.text = [self getDateStringWith:obj.dateStr];
            dateLabel.font = [UIFont systemFontOfSize:14.f];
            dateLabel.textColor = [UIColor colorWithHexColor:@"333333"];
            dateLabel.numberOfLines = 0;
            [dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(pointView);
                make.top.equalTo(self.lineView.mas_bottom).offset(2.f);
                make.width.mas_lessThanOrEqualTo(self.aAxisInstance);
            }];

        }
    }];
    [path stroke];
    layer.path = path.CGPath;
    UIGraphicsEndImageContext();
}
- (UIColor *)pointColorWith:(NSInteger)index  value:(CGFloat)value{
    UIColor *color = [UIColor colorWithHexColor:@"13ad67"];
    if (!self.standardValues) {
        NSArray *array = self.colors.firstObject;
        return array.count>0 ? array.firstObject : color;
    }
    if (index >= self.standardValues.count) {
        NSArray *array = self.colors.firstObject;
        return array.count>0 ? array.firstObject : color;
    }
    if (!self.colors) {
        return color;
    }
    if (index >= self.colors.count) {
        NSArray *array = self.colors.firstObject;
        return array.count>0 ? array.firstObject : color;
    }
    NSArray *lineStandValue = self.standardValues[index];
    NSArray *pointColors = self.colors[index];
    for (int i = 0; i<lineStandValue.count; i++) {
        CGFloat standValue = [lineStandValue[i] floatValue];
        if (value < standValue) {
            NSInteger colorCornerMark = i<pointColors.count ? i:0;
            return pointColors[colorCornerMark];
        }
        if (i == lineStandValue.count-1) {
            NSInteger colorCornerMark = i >= pointColors.count ? i:0;
            return pointColors[colorCornerMark];
        }
    }
    return color;
}
- (UIColor *)lineColorWith:(NSInteger)index{
    UIColor *color = [UIColor colorWithHexColor:@"13ad67"];
    if (!self.lineColors) {
        return color;
    }
    NSInteger idx = index >= self.lineColors.count ? 0:index;
    color = self.lineColors[idx];
    return color;
}

//时间格式化
- (NSString *)getDateStringWith:(NSString *)dateString{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [formatter dateFromString:dateString];
    NSDateFormatter *secondFormatter = [[NSDateFormatter alloc]init];
    NSString *dateFormat = self.dateFormatStyle ? self.dateFormatStyle:@"MM-dd";
    [secondFormatter setDateFormat:dateFormat];
    return [secondFormatter stringFromDate:date];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
