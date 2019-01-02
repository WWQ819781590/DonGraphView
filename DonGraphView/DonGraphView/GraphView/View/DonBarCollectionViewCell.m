//
//  DonBarCollectionViewCell.m
//  Test_TableView
//
//  Created by hongchao.li on 2018/9/25.
//  Copyright © 2018年 DonWang. All rights reserved.
//

#import "DonBarCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+DonHexColor.h"
@interface DonBarCollectionViewCell()
@property (nonatomic, strong)UIView *lineView;
@property (nonatomic, strong)UIView *inputView;
@property (nonatomic, strong)UIView *nightOutputView;
@property (nonatomic, strong)UIView *dayOutputView;
@property (nonatomic, strong)UILabel *inputLabel;
@property (nonatomic, strong)UILabel *nightOutputLabel;
@property (nonatomic, strong)UILabel *dayOutputLabel;
@property (nonatomic, strong)UILabel *dateLabel;
@end
@implementation DonBarCollectionViewCell


-(void)setModel:(DonGraphBarModel *)model{
//    DLog(@"%@",NSStringFromCGRect(self.frame));
    [self.contentView layoutIfNeeded];
//    DLog(@"%@",NSStringFromCGRect(self.lineView.frame));
    CGFloat maxHeight = CGRectGetMinY(self.lineView.frame);
    self.dateLabel.text = [self getDateStringWith:model.dateStr];
    
    CGFloat inputValue = model.valueArray.firstObject.floatValue;
    CGFloat nightValue = [model.valueArray[1] floatValue];
    CGFloat dayValue = [model.valueArray[2] floatValue];
    CGFloat inputScale = inputValue/(model.maxValue - model.minValue);

    CGFloat totalHeight = (nightValue+dayValue-model.minValue)/(model.maxValue - model.minValue);
    CGFloat nightScale = nightValue == 0 && dayValue == 0 ? 0:nightValue/(nightValue+dayValue)*totalHeight;
    CGFloat dayScale = nightValue == 0 && dayValue == 0 ? 0:dayValue/(nightValue+dayValue)*totalHeight;
    
    NSInteger isCenter = 0;
    if (inputValue == 0 && nightValue + dayValue == 0) {
        isCenter = 0;
    }else if (inputValue == 0){
        isCenter = 1;
    }else if (nightValue + dayValue == 0){
        isCenter = 2;
    }else{
        isCenter = 0;
    }
    
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(maxHeight*inputScale);
        if (isCenter == 2) {
            make.right.equalTo(self.contentView.mas_centerX).offset(10.f);
        }
    }];
    [self.nightOutputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(maxHeight*nightScale);
        if (isCenter == 1) {
            make.left.equalTo(self.contentView.mas_centerX).offset(-10.f);
        }
    }];
    [self.dayOutputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(maxHeight*dayScale);
    }];
    if (isCenter==2) {
        [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(-7);
        }];
    }else {
        [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView);
        }];
    }
    if (inputValue+nightValue==0 || inputValue+dayValue==0) {
        [self.dateLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView).offset(7);
        }];
    }else {
        
    }
    if (inputValue>=100) {
        [self.inputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputView).offset(4);
        }];
    }else {
        [self.inputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.inputView).offset(-8);
        }];
    }
    if (nightValue>=100 && dayValue>=100) {
        [self.nightOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nightOutputView).offset(4);
        }];
        [self.dayOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayOutputView).offset(4);
        }];
    }else if (nightValue>=100 && dayValue<100) {
        [self.nightOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nightOutputView).offset(4);
        }];
        [self.dayOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayOutputView).offset(-8);
        }];
    }else if (nightValue<100 && dayValue>=100) {
        [self.nightOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nightOutputView).offset(8);
        }];
        [self.dayOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayOutputView).offset(4);
        }];
    }else {
        [self.nightOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.nightOutputView).offset(8);
        }];
        [self.dayOutputLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.dayOutputView).offset(-8);
        }];
    }

    self.inputLabel.text = [model.valueArray[0] integerValue]>0?[NSString stringWithFormat:@"%ld",[model.valueArray[0] integerValue]]:@"";
    self.nightOutputLabel.text =[model.valueArray[1] integerValue]>0? [NSString stringWithFormat:@"%ld",[model.valueArray[1] integerValue]]:@"";
    self.dayOutputLabel.text =[model.valueArray[2] integerValue]>0? [NSString stringWithFormat:@"%ld",[model.valueArray[2] integerValue]]:@"";
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


- (void)prepareForReuse{
    [super prepareForReuse];
    [self.inputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.right.equalTo(self.contentView.mas_centerX).offset(-2.f);
    }];
    self.inputLabel.text = @"";
    
    [self.nightOutputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
        make.left.equalTo(self.contentView.mas_centerX).offset(2.f);
    }];
    self.nightOutputLabel.text = @"";
    
    
    [self.dayOutputView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0);
    }];
    self.dayOutputLabel.text = @"";
    self.dateLabel.text = @"";
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI];
    }
    return self;
}
- (void)setUpUI{
    UIView *lineView = [[UIView alloc]init];
    [self.contentView addSubview:lineView];
    lineView.backgroundColor = [UIColor colorWithHexColor:@"979797"];
    _lineView = lineView;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.contentView);
        make.height.mas_equalTo(1.f);
        make.bottom.equalTo(self.contentView).offset(-20);
    }];
    UILabel *label = [[UILabel alloc]init];
    [self.contentView addSubview:label];
    label.textColor = [UIColor colorWithHexColor:@"333333"];
    label.font = [UIFont systemFontOfSize:10.f];
    _dateLabel = label;
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom);
        make.centerX.equalTo(self.contentView);
    }];
    
    UIView *inputView = [[UIView alloc]init];
    [self.contentView addSubview:inputView];
    _inputView = inputView;
    inputView.backgroundColor = [UIColor colorWithHexColor:@"13ad67"];
    [inputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_centerX).offset(-2.f);
        make.width.mas_equalTo(self.contentView.mas_width).multipliedBy(1.f/3.f);
        make.bottom.equalTo(lineView.mas_top);
    }];
    UILabel *inputLabel = [[UILabel alloc]init];
    [self.contentView addSubview:inputLabel];
    _inputLabel = inputLabel;
    inputLabel.textColor = [UIColor colorWithHexColor:@"000000"];
    inputLabel.font = [UIFont systemFontOfSize:8.f];
    inputLabel.textAlignment = NSTextAlignmentCenter;
    [inputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(inputView).offset(8);
        make.centerX.equalTo(inputView);
        make.left.equalTo(inputView);
//        make.bottom.greaterThanOrEqualTo(inputView);
    }];
    
    
    
    UIView *nightOutputView = [[UIView alloc]init];
    [self.contentView addSubview:nightOutputView];
    _nightOutputView = nightOutputView;
    nightOutputView.backgroundColor = [UIColor colorWithHexColor:@"1296db"];
    [nightOutputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_centerX).offset(2.f);
        make.width.mas_equalTo(inputView.mas_width);
        make.bottom.equalTo(lineView.mas_top);
    }];
    UILabel *nightOutputLabel = [[UILabel alloc]init];
    [self.contentView addSubview:nightOutputLabel];
    _nightOutputLabel = nightOutputLabel;
    nightOutputLabel.textColor = [UIColor colorWithHexColor:@"000000"];
    nightOutputLabel.font = [UIFont systemFontOfSize:8.f];
    nightOutputLabel.textAlignment = NSTextAlignmentCenter;
    [nightOutputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nightOutputView).offset(8);
        make.centerX.equalTo(nightOutputView);
        make.left.equalTo(nightOutputView);
//        make.bottom.greaterThanOrEqualTo(nightOutputView);

    }];
    
    UIView *dayOutputView = [[UIView alloc]init];
    [self.contentView addSubview:dayOutputView];
    _dayOutputView = dayOutputView;
    dayOutputView.backgroundColor = [UIColor colorWithHexColor:@"ff9e21"];
    [dayOutputView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nightOutputView.mas_left);
        make.width.mas_equalTo(nightOutputView.mas_width);
        make.bottom.equalTo(nightOutputView.mas_top);
    }];
    UILabel *dayOutputLabel = [[UILabel alloc]init];
    [self.contentView addSubview:dayOutputLabel];
    _dayOutputLabel = dayOutputLabel;
    dayOutputLabel.textColor = [UIColor colorWithHexColor:@"000000"];
    dayOutputLabel.font = [UIFont systemFontOfSize:8.f];
    dayOutputLabel.textAlignment = NSTextAlignmentCenter;
    [dayOutputLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(dayOutputView).offset(8);
        make.centerX.equalTo(dayOutputView);
        make.left.equalTo(dayOutputView);
//        make.bottom.greaterThanOrEqualTo(dayOutputView);
    }];
}
@end
