//
//  XXPieChartData.m
//  XXChart
//
//  Created by NYZ Star on 8/22/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import "XXPieChartData.h"

@implementation XXPieChartData

-(id)initWithValue:(float)value color:(UIColor*)color description:(NSString*)description
{
    self = [super init];
    if(self)
    {
        _value = value;
        _color = color;
        _descript = description;
    }
    return self;
}

+(instancetype)chartDataWithValue:(float)value color:(UIColor*)color description:(NSString*)description
{
    return [[XXPieChartData alloc] initWithValue:value color:color description:description];
}

+(instancetype)chartDataWithValue:(float)value color:(UIColor*)color
{
    return [[XXPieChartData alloc] initWithValue:value color:color description:nil];
}
@end
