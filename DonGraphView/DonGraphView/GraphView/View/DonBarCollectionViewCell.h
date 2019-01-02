//
//  DonBarCollectionViewCell.h
//  Test_TableView
//
//  Created by hongchao.li on 2018/9/25.
//  Copyright © 2018年 DonWang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DonGraphBarModel.h"

@interface DonBarCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong)DonGraphBarModel *model;
@property (nonatomic, copy)NSString *dateFormatStyle;
@end
