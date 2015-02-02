//
//  XXChartDelegate.h
//  XXChart
//
//  Created by NYZ Star on 8/22/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#ifndef XXChart_XXChartDelegate_h
#define XXChart_XXChartDelegate_h

#import <Foundation/Foundation.h>
struct RectPos
{
    float top;
    float bottom;
    float left;
    float right;
};
typedef struct RectPos RectPos;

@protocol XXChartDelegate <NSObject>

@optional
/**
 * When user click on the chart line
 *
 */
//- (void)userClickedOnLinePoint:(CGPoint)point lineIndex:(NSInteger)lineIndex;

/**
 * When user click on the chart line key point
 *
 */
- (void)userClickedOnLineKeyPoint:(CGPoint)point lineIndex:(NSInteger)lineIndex andPointIndex:(NSInteger)pointIndex;

/**
 * When user click on a chart bar
 *
 */
- (void)userClickedOnBarCharIndex:(NSInteger)barIndex;

/**
 * When user click on a pie
 *
 */
- (void)userClickedOnPieCharIndex:(NSInteger)pieIndex;

@end

#endif
