//
//  XXPieChartData.h
//  XXChart
//
//  Created by NYZ Star on 8/22/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XXPieChartData : NSObject

+(instancetype)chartDataWithValue:(float)value color:(UIColor*)color;
+(instancetype)chartDataWithValue:(float)value color:(UIColor*)color description:(NSString*)description;

-(id)initWithValue:(float)value color:(UIColor*)color description:(NSString*)description;

@property (nonatomic, readonly) CGFloat   value;
@property (nonatomic, readonly) UIColor  *color;
@property (nonatomic, readonly) NSString *descript;

@end
