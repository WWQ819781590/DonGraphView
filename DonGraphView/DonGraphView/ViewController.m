//
//  ViewController.m
//  DonGraphView
//
//  Created by hongchao.li on 2019/1/2.
//  Copyright © 2019 hongchao.li. All rights reserved.
//

#import "ViewController.h"
#import "DonGraphScrollView.h"
@interface ViewController ()
@property (nonatomic, strong)DonGraphScrollView *graphView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
 
}
-(DonGraphScrollView *)graphView{
    if (!_graphView) {
        _graphView = [[DonGraphScrollView alloc]init];
    }
    return _graphView;
}

@end
