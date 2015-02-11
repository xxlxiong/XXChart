//
//  XXLineChart.h
//  XXChart
//
//  Created by NYZ Star on 8/20/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XXChartDelegate.h"

@interface XXLineChart : UIView
{
    CAShapeLayer *conentLayer;
    CAShapeLayer *selectShowLayer;
    float xAxisLength;
    float yAxisLength;
    
    CGPoint pTouchPoint;
    CGPoint selectedPoint;
    
    CGPoint xOriginPoint;   //逻辑上x轴起始点<-计算用这个
    CGPoint yOriginPoint;   //y轴起始点
    NSUInteger xBeginIndex; //x轴从数据集中第几个开始显示(即处于xBeginIndex位置的xLabels元素为x轴开始数值
    float xMoveDistance;
    BOOL    isReDrawContent;
    
    NSMutableArray *xLabelLayers;
    NSMutableArray *yLabelLayers;
    
    NSMutableArray *chartLineArray;
    NSMutableArray *chartPointArray;
    
    NSMutableArray *chartPath;       // Array of line path, one for each line.
    NSMutableArray *pointPath;       // Array of point path, one for each line
    
    NSMutableArray *pathPoints;
    
    float yValueMax,yValueMin;
    float canvanHeight; //平均高度
}

-(void)strokeChart:(BOOL)isAnimation duration:(NSTimeInterval)duration;

//@property (nonatomic, retain) id<XXChartDelegate> delegate;

@property (nonatomic) NSArray *xLabels;
@property (nonatomic) NSArray *yLabels;

@property (nonatomic) BOOL showXLabel;
@property (nonatomic) BOOL showYLabel;

@property (nonatomic) NSMutableArray *yLineData;
/**
 *  arrayIndex-从array中第arrayIndex的元素开始显示
 */
-(void)setXLabels:(NSArray *)xLabels originIndex:(NSUInteger)arrayIndex;
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
 * Array of `LineChartData` objects, one for each line.
 */
@property (nonatomic) NSArray *chartData;

/**
 *  default is true
 */
@property (nonatomic) BOOL ScrollEnable;
/**
 *  show CoordinateAxis ornot, Default is not
 */
@property (nonatomic, getter = isShowCoordinateAxis) BOOL showCoordinateAxis;

@property (nonatomic, assign) id<XXChartDelegate> delegate;

/**
 *  select point
 */
@property (nonatomic) BOOL isAllowPointSelect;
@property (nonatomic) UIColor *selectPointColor;
@property (nonatomic) float pointRadius;

/*
 *  selected point is filled color
 */
@property (nonatomic) BOOL isFill;

@end
