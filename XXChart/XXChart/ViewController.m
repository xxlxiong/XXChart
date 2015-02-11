//
//  ViewController.m
//  XXChart
//
//  Created by XXL on 2/2/15.
//  Copyright (c) 2015 OoO. All rights reserved.
//

#import "ViewController.h"
#import "XXLineChart.h"
#import "XXLineChartData.h"
#import "XXColors.h"

@interface ViewController ()<XXChartDelegate>
@property (weak, nonatomic) IBOutlet XXLineChart *lineChart;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _lineChart.xUnitDis = 40;
    [_lineChart setXLabels:@[@"20",@"40",@"60",@"80",@"100",@"120",@"140",@"160"] originIndex:0];
    _lineChart.yLabels = @[@"0",@"20",@"40",@"60",@"80"];
    XXLineChartData *lineData = [XXLineChartData getLineChartDataByArray:@[@"0.0",@"0.0",@"35.0",@"40"]];
    lineData.inflexionPointStyle=LineChartPointStyleCycle;
    lineData.color = PNGreen;
    _lineChart.chartData = @[lineData];
    _lineChart.delegate = self;
    
    [_lineChart strokeChart:YES duration:1.0];
}

-(void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex{
    NSLog(@"Click Key on line %f, %f line index is %d and point index is %d",point.x, point.y,(int)lineIndex, (int)pointIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
