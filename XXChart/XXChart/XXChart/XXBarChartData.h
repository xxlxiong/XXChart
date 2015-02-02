//
//  XXBarChartData.h
//  XXChart
//
//  Created by NYZ Star on 8/26/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXBarChartData : NSObject

@property (nonatomic) float value;
@property (nonatomic) UIColor *color;
@property (nonatomic) NSString *text;

+(instancetype)XXBarChartDataWithValue:(float)value color:(UIColor*)color   description:(NSString*)description;
+(instancetype)XXBarChartDataWithValue:(float)value color:(UIColor*)color;

@end
