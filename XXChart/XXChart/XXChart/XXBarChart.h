//
//  XXBarChart.h
//  XXChart
//
//  Created by NYZ Star on 8/26/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXChartDelegate.h"

@interface XXBarChart : UIView
{
    CAShapeLayer *conentLayer;
    float xAxisLength;
    float yAxisLength;
    
    CGPoint pTouchPoint;
    CGPoint xOriginPoint;   //逻辑上x轴起始点<-计算用这个
    CGPoint yOriginPoint;   //y轴起始点
    float xMoveDistance;
    
    NSMutableArray *barPath;
    
    NSMutableArray *barLayers;
    
    NSMutableArray *xLabelLayers;
    NSMutableArray *yLabelLayers;
    
    float yValueMax,yValueMin;
    float canvanHeight; //平均高度
}

-(void)strokeChart:(BOOL)isAnimation duration:(NSTimeInterval)duration;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;

@property (nonatomic) BOOL showXLabel;
@property (nonatomic) BOOL showYLabel;

/**
 *  x,y axis unit distance,default show all units
 *  x,y轴上坐标点之间的距离，默认显示所有坐标点，距离为轴长/坐标点个数
 */
@property (nonatomic) float xUnitDis;
@property (nonatomic) float yUnitDis;
/**
 *  margin between border,default 40
 *  与四周边界的距离,默认为40
 */
@property (nonatomic) RectPos chartMargin;

/*
 *  轴线粗细，默认为2
 */
@property (nonatomic) float axisWidth;
@property (nonatomic) UIColor *axisColor;

//y轴漂移原点距离，默认为0
@property (nonatomic) CGFloat yAsixOffset;
/**
 *  x and y axis point separator,default is frame.length/pointNumber
 *  x与y轴上坐标点之间的距离，默认自适应当前大小
 */
@property (nonatomic) float xSeparator;
@property (nonatomic) float ySeparator;

/**
 * Array of `XXBarChartData` objects.
 */
@property (nonatomic) NSArray *barChartData;

/**
 *  default is true
 */
@property (nonatomic) BOOL ScrollEnable;

@property (nonatomic) BOOL showCoordinateAxis;

@property (nonatomic,weak) id<XXChartDelegate> delegate;

/**********************bar  properties***********************/
@property (nonatomic) float barWidth;

@end
