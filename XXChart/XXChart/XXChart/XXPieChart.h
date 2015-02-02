//
//  XXPieChart.h
//  XXChart
//
//  Created by NYZ Star on 8/22/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXChartDelegate.h"
#import "XXPieChartData.h"

@interface XXPieChart : UIView
{
    float total;
    CGPoint center ;
    
    CAShapeLayer *pieLayer;
    NSMutableArray *piePaths;
    NSMutableArray *descriptionLabels;
}

- (id)initWithFrame:(CGRect)frame items:(NSArray *)items;

@property (nonatomic) NSArray	*items;
@property (nonatomic) float outterCircleRadius;
@property (nonatomic) float innerCircleRadius;

@property (nonatomic, weak) id<XXChartDelegate> delegate;


///description text
@property (nonatomic) UIFont  *descriptionTextFont;  //default is [UIFont fontWithName:@"Avenir-Medium" size:18.0];
@property (nonatomic) UIColor *descriptionTextColor; //default is [UIColor whiteColor]
@property (nonatomic) UIColor *descriptionTextShadowColor; //default is [[UIColor blackColor] colorWithAlphaComponent:0.4]
@property (nonatomic) CGSize   descriptionTextShadowOffset; //default is CGSizeMake(0, 1)

- (void)strokeChart:(BOOL)animation duration:(NSTimeInterval)duration;

@end
