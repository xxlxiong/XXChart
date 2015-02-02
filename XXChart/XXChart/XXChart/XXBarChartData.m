//
//  XXBarChartData.m
//  XXChart
//
//  Created by NYZ Star on 8/26/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import "XXBarChartData.h"

@implementation XXBarChartData

+(instancetype)XXBarChartDataWithValue:(float)value color:(UIColor*)color   description:(NSString*)description
{
    XXBarChartData *barChartData = [XXBarChartData new];
    barChartData.value = value;
    barChartData.color = color;
    barChartData.text = description;
    return barChartData;
}

+(instancetype)XXBarChartDataWithValue:(float)value color:(UIColor*)color
{
    return [XXBarChartData XXBarChartDataWithValue:value color:color description:nil];
}

@end
