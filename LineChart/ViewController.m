//
//  ViewController.m
//  LineChart
//
//  Created by JYH on 16/8/2.
//  Copyright © 2016年 JYH. All rights reserved.
//

#import "ViewController.h"
#import "FJLineView.h"

#define ARColor(r, g, b) \
[UIColor colorWithRed:(r) / 255.0f \
green:(g) / 255.0f \
blue:(b) / 255.0f \
alpha:1]

#define ARScreenW [UIScreen mainScreen].bounds.size.width

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIView *chartView;
/** 图表内容*/
@property (nonatomic, weak) FJLineView *lineView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self addLineChart];
}

- (void)addLineChart{
    
    FJLineView* LineView=[[FJLineView alloc] initWithFrame:CGRectMake(0, 0,ARScreenW - 40, self.chartView.frame.size.height)];
    LineView.xValues=@[@20,@50,@80,@110,@210,@250,@270];                               //设置X值
    LineView.yValues=@[@2.445,@2.444,@2.440,@2.441,@2.439,@2.437,@2.437];              //设置Y值
    LineView.xKeDuValus=@[@"6-22",@"6-23",@"6-24",@"6-25",@"6-26",@"6-27",@"6-28"];    //设置X坐标轴
    LineView.yKeDuValus=@[@2.42,@2.43,@2.44,@2.45,@2.46,@2.47];                        //设置Y坐标轴
    LineView.yValueColor=ARColor(221, 221, 221);
    LineView.xValueColor=ARColor(221, 221, 221);
    
    [self.chartView addSubview:LineView];
    self.lineView = LineView;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
