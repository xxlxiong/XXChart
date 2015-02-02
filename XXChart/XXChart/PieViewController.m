//
//  PieViewController.m
//  XXChart
//
//  Created by XXL on 2/2/15.
//  Copyright (c) 2015 OoO. All rights reserved.
//

#import "PieViewController.h"
#import "XXPieChartData.h"
#import "XXColors.h"

@interface PieViewController ()

@end

@implementation PieViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSArray *items = @[[XXPieChartData chartDataWithValue:10 color:PNLightGreen],
                       [XXPieChartData chartDataWithValue:20 color:PNFreshGreen description:@"WWDC"],
                       [XXPieChartData chartDataWithValue:40 color:PNDeepGreen description:@"GOOL I/O"],
                       ];
    _pieView.items = items;
    _pieView.delegate = self;
    _pieView.innerCircleRadius = 0;
    [_pieView strokeChart:YES duration:2.0];
}

- (IBAction)redraw:(id)sender {
    NSArray *items = @[[XXPieChartData chartDataWithValue:10 color:PNLightGreen],
                       [XXPieChartData chartDataWithValue:10 color:PNFreshGreen],
                       [XXPieChartData chartDataWithValue:10 color:PNDeepGreen],
                       ];
    _pieView.items = items;
    _pieView.delegate = self;
    [_pieView strokeChart:YES duration:2.0];
}

- (void)userClickedOnPieCharIndex:(NSInteger)pieIndex
{
    NSLog(@"click char:%ld",pieIndex);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
