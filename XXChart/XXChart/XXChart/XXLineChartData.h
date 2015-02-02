//
//  XXLineChartData.h
//  XXChart
//
//  Created by NYZ Star on 8/21/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LineChartPointStyle) {
    
    LineChartPointStyleNone = 0,
    LineChartPointStyleCycle,
    LineChartPointStyleTriangle,
    LineChartPointStyleSquare
};

@interface XXLineChartData : NSObject

@property (strong) UIColor *color;

@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic, assign) LineChartPointStyle inflexionPointStyle;

@property (nonatomic, assign) CGFloat inflexionPointWidth;
@property (nonatomic, assign) CGFloat lineWidth;

+(instancetype)getLineChartDataByArray:(NSArray*)array;
@end
