//
//  PieViewController.h
//  XXChart
//
//  Created by XXL on 2/2/15.
//  Copyright (c) 2015 OoO. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXPieChart.h"

@interface PieViewController : UIViewController<XXChartDelegate>
@property (weak, nonatomic) IBOutlet XXPieChart *pieView;

@end
