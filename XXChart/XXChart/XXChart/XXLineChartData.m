//
//  XXLineChartData.m
//  XXChart
//
//  Created by NYZ Star on 8/21/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import "XXLineChartData.h"


@implementation XXLineChartData
- (id)init
{
    self = [super init];
    if (self) {
        
        [self setDefaultValues];
    }
    
    return self;
}

- (void)setDefaultValues
{
    _inflexionPointStyle = LineChartPointStyleNone;
    _inflexionPointWidth = 6.f;
    _lineWidth = 2.f;
}

+(instancetype)getLineChartDataByArray:(NSArray*)array
{
    XXLineChartData *lineCharData = [[XXLineChartData alloc] init];
    lineCharData.dataArray = array;
    
    return lineCharData;
}

@end
