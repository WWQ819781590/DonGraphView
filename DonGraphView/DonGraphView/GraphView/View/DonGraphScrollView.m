//
//  DonGraphScrollView.m
//  Test_TableView
//
//  Created by hongchao.li on 2018/9/21.
//  Copyright © 2018年 DonWang. All rights reserved.
//
//#define Hortical_Width  50.f
#import "DonGraphScrollView.h"

#import "DonGraphPointModel.h"
#import "DonGraphBarModel.h"

#import "DonLineView.h"
#import "DonBarCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+DonHexColor.h"
@interface DonGraphScrollView()<UICollectionViewDelegate,UICollectionViewDataSource>

//数据
@property (nonatomic, strong)NSArray *dataArray;
//纵轴上的label数组
@property (nonatomic, strong)NSArray <UILabel *>*verticalLabelArray;
//单位
@property (nonatomic, strong)UILabel *unitLabel;
@property (nonatomic, strong)UIScrollView *scrollView;
@property (nonatomic, strong)UICollectionView *collectionView;
@property (nonatomic, assign)CGSize itemSize;


//纵轴
@property (nonatomic, strong)UIView *verticalView;
//纵轴label等距的底层视图
@property (nonatomic, strong)UIView *verticalBackView;

//纵轴上的最大最小值
@property (nonatomic, assign)CGFloat verticalMaxValue;
@property (nonatomic, assign)CGFloat verticalMinValue;
//画板
@property (nonatomic, strong)DonLineView *lineView;

@property (nonatomic, assign)CGFloat verticalMaxHeight;

@end
@implementation DonGraphScrollView
- (void)begainGraphWith:(NSArray <DonGraphPointModel *>*)dataArray{
//    self.dataArray = dataArray;
    NSLog(@"%@",NSStringFromCGRect(self.verticalBackView.frame));
    self.verticalMaxHeight = CGRectGetHeight(self.verticalBackView.frame);
    if (self.viewStyle == GraphViewStyleLine) {
        NSMutableArray *array = [NSMutableArray arrayWithCapacity:0];
        if (self.normalValue_MinStr) {
            [array addObject:self.normalValue_MinStr];
        }
        if (self.normalValue_MaxStr) {
            [array addObject:self.normalValue_MaxStr];
        }
        
        if (!self.standardValues) {
            self.standardValues = @[array.copy];
        }
        if (!self.colors) {
            self.colors = @[@[self.abnormalViewColor,self.normalViewColor]];
        }
        if (!self.lineColors) {
            self.lineColors = @[self.lineColor];
        }
        
        NSMutableArray *colorArray = [NSMutableArray arrayWithCapacity:0];
        if (self.abnormalViewColor) {
            [colorArray addObject:self.abnormalViewColor];
        }
        if (self.normalViewColor) {
            [colorArray addObject:self.normalViewColor];
        }

        [DonGraphPointModel getMaxAndMin:dataArray value:^(CGFloat max, CGFloat min) {
            CGFloat normalValue_Max = self.normalValue_MaxStr ? [self.normalValue_MaxStr floatValue] : max;
            CGFloat normalValue_Min = self.normalValue_MinStr ? [self.normalValue_MinStr floatValue] : max;
            CGFloat maxValue = max > normalValue_Max ? max : normalValue_Max;
            CGFloat minValue = min < normalValue_Min ? min : normalValue_Min;
            if(maxValue == 0 && minValue == 0){
                maxValue = 1;
                minValue = -1;
            }
            //        数据大于0和小于0时的边界值计算
            self.verticalMaxValue = maxValue * (maxValue > 0 ? 1.2 : 0.8);
            self.verticalMinValue = minValue * (minValue > 0 ? 0.8 : 1.2);
        }];
        [self drawLineViewWith:dataArray];
    }else{
        [DonGraphPointModel getBarViewMaxAndMin:dataArray value:^(CGFloat max, CGFloat min) {
            CGFloat normalValue_Max = self.normalValue_MaxStr ? [self.normalValue_MaxStr floatValue] : max;
            CGFloat normalValue_Min = self.normalValue_MinStr ? [self.normalValue_MinStr floatValue] : max;
            CGFloat maxValue = max > normalValue_Max ? max : normalValue_Max;
            CGFloat minValue = min < normalValue_Min ? min : normalValue_Min;
            if(maxValue == 0 && minValue == 0){
                maxValue = 1;
                minValue = -1;
            }
            //        数据大于0和小于0时的边界值计算
            self.verticalMaxValue = maxValue * (maxValue > 0 ? 1.2 : 0.8);
            self.verticalMinValue = minValue * (minValue > 0 ? 0.8 : 1.2);
        }];
        [self drawBarViewWith:dataArray];
    }
   
//    纵轴label赋值
    for (int i = 0; i<self.verticalLabelArray.count; i++) {
        UILabel *label = self.verticalLabelArray[i];
        CGFloat value = self.verticalMaxValue - (self.verticalMaxValue - self.verticalMinValue)/(self.verticalLabelArray.count-1)*i;
        if (self.viewStyle == GraphViewStyleLine) {
            label.text = [NSString stringWithFormat:@"%.1f",value];
        }else {
            label.text = [NSString stringWithFormat:@"%.f",value];
        }
    }    
}
#pragma mark =======  折线图
- (void)drawLineViewWith:(NSArray *)pointArray{
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];

    self.scrollView.hidden = NO;
    self.collectionView.hidden = YES;
   
    NSInteger count = pointArray.count >7 ? 7 : pointArray.count;
    CGFloat aAxisInstance = CGRectGetWidth(self.collectionView.frame)/(count == 0 ? 1 : count);

    self.scrollView.contentSize = CGSizeMake(aAxisInstance*pointArray.count, CGRectGetHeight(self.scrollView.frame));
    DonLineView *lineView = [[DonLineView alloc]initWithFrame:CGRectMake(0, 0, self.scrollView.contentSize.width, self.scrollView.contentSize.height)];
    _lineView = lineView;
    lineView.pointArray = pointArray;
    lineView.aAxisInstance = aAxisInstance;
    lineView.verticalMaxValue = self.verticalMaxValue;
    lineView.verticalMinValue = self.verticalMinValue;
    lineView.colors = self.colors;
    lineView.standardValues = self.standardValues;
    lineView.lineColors = self.lineColors;
    if ([self.from isEqualToString:@"0"]) {
        lineView.maxHeight = self.verticalMaxHeight;
    }else {
        lineView.maxHeight = self.verticalMaxHeight+19;
    }
    lineView.dateFormatStyle = self.dateFormatStyle;
    [self.scrollView addSubview:lineView];
    [lineView begainDraw];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@,%@",NSStringFromCGSize(self.scrollView.contentSize),NSStringFromCGRect(self.scrollView.frame));
        if (aAxisInstance*pointArray.count > CGRectGetWidth(self.scrollView.frame)) {
            [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-CGRectGetWidth(self.scrollView.frame), 0)];
        }
    });
}
#pragma mark - 柱状图
- (void)drawBarViewWith:(NSArray <DonGraphPointModel *>*)pointArray{
    
    self.scrollView.hidden = YES;
    self.collectionView.hidden = NO;
    [self.collectionView layoutSubviews];
    NSMutableArray *dataArray = [NSMutableArray arrayWithCapacity:0];
    [pointArray enumerateObjectsUsingBlock:^(DonGraphPointModel  * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DonGraphBarModel *model = [[DonGraphBarModel alloc]init];
        model.valueArray = obj.valueArray;
        model.dateStr = obj.dateStr;
        model.maxValue = self.verticalMaxValue;
        model.minValue = self.verticalMinValue;
        [dataArray addObject:model];
    }];
    self.dataArray = dataArray.copy;
    self.itemSize = CGSizeMake(CGRectGetWidth(self.collectionView.frame)/5.f, CGRectGetHeight(self.collectionView.frame));
    [self.collectionView reloadData];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (pointArray.count>0) {
            NSIndexPath *scrollIndex= [NSIndexPath indexPathForRow:pointArray.count-1 inSection:0];
            [self.collectionView scrollToItemAtIndexPath:scrollIndex atScrollPosition:(UICollectionViewScrollPositionRight) animated:YES];
        }
        
    });
}

//绘制虚线
- (void)drawDottedLineWith:(CGFloat)numberValue colorWith:(UIColor *)color{
    NSAssert(numberValue>=self.verticalMinValue || numberValue<=self.verticalMaxValue,@"不要搞事情,虚线画出视图外边去了" );
    //    CGFloat x =  0;
    //    CGFloat y = (self.verticalMaxValue - numberValue)/(self.verticalMaxValue - self.verticalMinValue)*self.boardHeight+self.topSpace;
//    if(!self.dataArray){
//        return;
//    }

    UIView *dottedView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self addSubview:dottedView];
    CGFloat height = self.verticalMaxHeight*(self.verticalMaxValue - numberValue)/(self.verticalMaxValue - self.verticalMinValue);
    [dottedView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verticalBackView.mas_right);
        make.top.equalTo(self.verticalBackView.mas_top).offset(height);
        make.right.equalTo(self.scrollView.mas_right);
        make.height.mas_equalTo(1.f);
    }];
    
    UIColor *lineColor = [UIColor whiteColor];
    if (color) {
        lineColor = color;
    }
    [self drawDashLine:dottedView lineLength:3 lineSpacing:7 lineColor:lineColor];
}
- (void)drawDashLine:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor
{
    [lineView layoutIfNeeded];
//    DLog(@"%@",NSStringFromCGRect(lineView.frame));
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2.f, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
    CABasicAnimation *ani = [CABasicAnimation animationWithKeyPath:NSStringFromSelector(@selector(strokeEnd))];
    
    ani.fromValue = @0;
    
    ani.toValue = @1;
    
    ani.duration = 0.5;
    
    //    ani.delegate = self;
    
    [shapeLayer addAnimation:ani forKey:NSStringFromSelector(@selector(strokeEnd))];
}
#pragma mark ======== UICollectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count > 5 ? self.dataArray.count : 5;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DonBarCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"DonBarCollectionViewCell" forIndexPath:indexPath];
    cell.dateFormatStyle = self.dateFormatStyle;
    if (indexPath.row < self.dataArray.count) {
        cell.model = self.dataArray[indexPath.row];

    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.itemSize;
}





-(void)setTextColor:(UIColor *)textColor{
    _textColor = textColor;
    self.unitLabel.textColor = textColor;
    for (UILabel *label in self.verticalLabelArray) {
        label.textColor = textColor;
    }
}
-(void)setLineColor:(UIColor *)lineColor{
    _lineColor = lineColor;
    self.verticalView.backgroundColor = lineColor;

}
-(void)setNormalViewColor:(UIColor *)normalViewColor{
    _normalViewColor = normalViewColor;
    
}
-(void)setAbnormalViewColor:(UIColor *)abnormalViewColor{
    _abnormalViewColor = abnormalViewColor;
    
}
-(void)setViewStyle:(GraphViewStyle)viewStyle{
    _viewStyle = viewStyle;
    
}
-(void)setUnitString:(NSString *)unitString{
    _unitString = unitString;
    self.unitLabel.text = unitString;
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        [self setUpUI];
    }
    return self;
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [self setUpUI];
}
- (void)setUpUI{
    self.viewStyle = GraphViewStyleLine;
    self.normalValue_MaxStr = nil;
    self.normalValue_MinStr = nil;
    self.textColor = [UIColor colorWithHexColor:@"333333"];
    self.normalViewColor = [UIColor colorWithHexColor:@"13ad67"];
    self.abnormalViewColor = [UIColor colorWithHexColor:@"ea5757"];
    self.lineColor = [UIColor colorWithHexColor:@"979797"];

    
    UIView *topView = [[UIView alloc]init];
    [self addSubview:topView];
    _topView = topView;
//    topView.backgroundColor = [UIColor colorWithHexColor:@"ff0000"];
    [topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self);
        make.height.mas_equalTo(25.f);
    }];
    
    UILabel *unitLabel = [[UILabel alloc]init];
    [topView addSubview:unitLabel];
    unitLabel.font = [UIFont systemFontOfSize:10.f];
    unitLabel.textColor = self.textColor;
    unitLabel.text = @"model";
    _unitLabel = unitLabel;
    [unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(topView).offset(15.f);
        make.centerY.equalTo(topView);
    }];

    
    UIView *bottomView = [[UIView alloc]init];
    [self addSubview:bottomView];
    _bottomView = bottomView;
//    bottomView.backgroundColor = [UIColor redColor];
    [bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self);
        make.height.mas_equalTo(25.f);
    }];
    
    
    UIView *verticalBackView = [[UIView alloc]init];
    verticalBackView.backgroundColor = [UIColor clearColor];
    [self addSubview:verticalBackView];
//    verticalBackView.clipsToBounds = YES;
    _verticalBackView = verticalBackView;
    [verticalBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(topView.mas_bottom);
        make.bottom.mas_equalTo(bottomView.mas_top).offset(-30.f);
    }];
    //    纵轴上的label
    NSMutableArray *axisLabelArray = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<6 ; i++) {
        UILabel *firstLabel = [[UILabel alloc]init];
        [verticalBackView addSubview:firstLabel];
        firstLabel.text = @"0";
        firstLabel.textColor = self.textColor;
        firstLabel.font = [UIFont systemFontOfSize:14.f];
        [axisLabelArray addObject:firstLabel];
    }
    self.verticalLabelArray = axisLabelArray.copy;
    [self.verticalLabelArray mas_distributeViewsAlongAxis:MASAxisTypeVertical withFixedSpacing:24.f leadSpacing:0 tailSpacing:0];
    [self.verticalLabelArray mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalBackView).offset(5.f);
        make.right.equalTo(verticalBackView).offset(-2.f);
    }];
    UIView *lineView = [[UIView alloc]init];
    [verticalBackView addSubview:lineView];
    _verticalView = lineView;
    lineView.backgroundColor = self.lineColor;
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(verticalBackView);
        make.width.mas_equalTo(1.f);
        make.top.bottom.equalTo(verticalBackView);
    }];
    
    
    
    
    
    [self addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalBackView.mas_right);
        make.right.equalTo(self).offset(-15.f);
        make.bottom.equalTo(bottomView.mas_top);
        make.top.equalTo(verticalBackView.mas_top);
    }];
    
    [self addSubview:self.collectionView];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(verticalBackView.mas_right);
        make.right.equalTo(self).offset(-15.f);
        make.bottom.equalTo(bottomView.mas_top);
        make.top.equalTo(verticalBackView);
    }];
    [self layoutIfNeeded];
//    DLog(@"%@",NSStringFromCGRect(self.verticalBackView.frame));
    
}

-(UIScrollView *)scrollView{
    if(!_scrollView){
        CGRect rect = self.frame;
        _scrollView = [[UIScrollView alloc]initWithFrame: CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.contentSize = CGSizeMake(rect.size.width, 0);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
    }
    return _scrollView;
}
-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.minimumLineSpacing = 0.f;
        layout.minimumInteritemSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        [_collectionView registerClass:[DonBarCollectionViewCell class] forCellWithReuseIdentifier:@"DonBarCollectionViewCell"];
    }
    return _collectionView;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
