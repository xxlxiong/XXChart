//
//  XXBarChart.m
//  XXChart
//
//  Created by NYZ Star on 8/26/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import "XXBarChart.h"

@implementation XXBarChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        conentLayer = [CAShapeLayer new];
        conentLayer.backgroundColor = [UIColor clearColor].CGColor;
        conentLayer.frame = self.bounds;
        [self.layer addSublayer:conentLayer];
        [self setDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    
    if (self) {
        conentLayer = [CAShapeLayer new];
        conentLayer.backgroundColor = [UIColor clearColor].CGColor;
        conentLayer.frame = self.bounds;
        [self.layer addSublayer:conentLayer];
        self.clipsToBounds = YES;
        [self setDefaults];
    }
    
    return self;
}

-(void)setDefaults
{
    _showCoordinateAxis = YES;
    _ScrollEnable = YES;
    _showXLabel = YES;
    _showYLabel = YES;
    _yAsixOffset = 0;
    _axisWidth = 2.0f;
    _axisColor = [UIColor blackColor];
    
    //据四周默认为20
    _chartMargin.top=20;
    _chartMargin.bottom = 20;
    _chartMargin.left=20;
    _chartMargin.right=20;
    
    barLayers = [NSMutableArray array];
    barPath = [NSMutableArray array];
    [self defineRect];
}

-(void)defineRect
{
    yAxisLength = CGRectGetHeight(self.frame) - _chartMargin.top-_chartMargin.bottom;
    xAxisLength = MAX(CGRectGetWidth(self.frame) - _chartMargin.left-_chartMargin.right,_xUnitDis*_xLabels.count);
    
    xOriginPoint = CGPointMake(_chartMargin.left,yAxisLength+_chartMargin.top);
    yOriginPoint = CGPointMake(_chartMargin.left+_yAsixOffset, _chartMargin.top);
    
}

-(void)setChartMargin:(RectPos)chartMargin
{
    _chartMargin = chartMargin;
    [self defineRect];
}

-(void)setXLabels:(NSArray *)xLabels
{
    if(!_xUnitDis)
        _xUnitDis = (xAxisLength-6)/xLabels.count;
    else
        xAxisLength = MAX(xAxisLength,_xUnitDis*_xLabels.count);
    
    if(!xLabelLayers)
        xLabelLayers = [NSMutableArray array];
    _xLabels = xLabels;
    
}

-(void)showXLabels
{
    //显示x坐标点数值
    if (_showXLabel) {
        for(int i=0;i<_xLabels.count;i++)
        {
            NSString *labelText = _xLabels[i];
            CATextLayer *textLayer = [CATextLayer new];
            if(xOriginPoint.x+i*_xUnitDis<_chartMargin.left)
                continue;
            textLayer.frame = CGRectMake(xOriginPoint.x+i*_xUnitDis-_xUnitDis/2, xOriginPoint.y+2, _xUnitDis, 20);
            textLayer.string = labelText;
            textLayer.fontSize = 12;
            textLayer.alignmentMode = @"center";
            textLayer.foregroundColor= _axisColor.CGColor;
            
            [self.layer addSublayer:textLayer];
            [xLabelLayers addObject:textLayer];
        }
    }
}

-(void)setYLabels:(NSArray *)yLabels
{
    if(!_yUnitDis)
        _yUnitDis = (yAxisLength-6)/yLabels.count;
    if(!yLabelLayers)
        yLabelLayers = [NSMutableArray array];
    _yLabels = yLabels;
    [self setNeedsDisplay];
}

-(void)showYLabels
{
    if(_showYLabel)
    {
        yValueMax = yValueMin = 0;
        for(int i=0;i<_yLabels.count;i++)
        {
            NSString *labelText = _yLabels[i];
            CATextLayer *textLayer = [CATextLayer new];
            textLayer.frame = CGRectMake(yOriginPoint.x-5-25, yOriginPoint.y+yAxisLength-i*_yUnitDis-7, 25, 15);
            textLayer.string = labelText;
            textLayer.fontSize = 12;
            textLayer.alignmentMode = @"right";
            textLayer.foregroundColor= _axisColor.CGColor;
            
            [self.layer addSublayer:textLayer];
            [yLabelLayers addObject:textLayer];
            
            yValueMax = MAX([labelText floatValue],yValueMax);
            yValueMin = MIN([labelText floatValue],yValueMin);
        }
        if(_yLabels.count)
            canvanHeight = (_yUnitDis*(_yLabels.count-1))/(yValueMax-yValueMin);
    }
}

-(void)strokeChart:(BOOL)isAnimation duration:(NSTimeInterval)duration
{
    
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Draw X axis and Y axis
    if (_showCoordinateAxis) {
        
        //draw yaxis,it can't scroll
        CGContextRef ctx = UIGraphicsGetCurrentContext();
        UIGraphicsPushContext(ctx);
        CGContextSetLineWidth(ctx, self.axisWidth);
        CGContextSetStrokeColorWithColor(ctx, [self.axisColor CGColor]);
        
        CGFloat yAxisHeight = CGRectGetHeight(rect) - _chartMargin.top-_chartMargin.bottom;
        CGFloat xAxisWidth = MAX(CGRectGetWidth(rect) - _chartMargin.left-_chartMargin.right,_xUnitDis*_xLabels.count);
        
        //draw y axis line
        CGContextMoveToPoint(ctx, yOriginPoint.x, yOriginPoint.y);
        CGContextAddLineToPoint(ctx, yOriginPoint.x, yAxisHeight+yOriginPoint.y);
        CGContextStrokePath(ctx);
        
        //draw y arrow
        // draw y axis arrow
        CGContextMoveToPoint(ctx, yOriginPoint.x - 4, yOriginPoint.y+6);
        CGContextAddLineToPoint(ctx, yOriginPoint.x, yOriginPoint.y);
        CGContextAddLineToPoint(ctx, yOriginPoint.x + 4, yOriginPoint.y+6);
        CGContextStrokePath(ctx);
        
        //draw x axis by touchPoint
        //
        //show x axis
        CGContextMoveToPoint(ctx,_chartMargin.left, xOriginPoint.y);
        CGContextAddLineToPoint(ctx, xOriginPoint.x+xAxisWidth, xOriginPoint.y);
        CGContextStrokePath(ctx);
        
        //draw x axis arrow
        CGContextMoveToPoint(ctx,xOriginPoint.x+xAxisWidth-6, xOriginPoint.y-4);
        CGContextAddLineToPoint(ctx,xOriginPoint.x+xAxisWidth, xOriginPoint.y);
        CGContextAddLineToPoint(ctx,xOriginPoint.x+xAxisWidth-6, xOriginPoint.y+4);
        CGContextStrokePath(ctx);
        
        
        //draw Y axis separator
        for(uint i=0;i<_yLabels.count;i++)
        {
            CGPoint point = CGPointMake(yOriginPoint.x, yOriginPoint.y+yAxisHeight-i*_yUnitDis);
            CGContextMoveToPoint(ctx, point.x+3, point.y);
            CGContextAddLineToPoint(ctx, point.x, point.y);
            CGContextStrokePath(ctx);
        }
        
        //draw X axis separator
        for (int i=0;i<_xLabels.count;i++) {
            CGPoint point = CGPointMake(xOriginPoint.x+i*_xUnitDis, xOriginPoint.y);
            if(point.x<_chartMargin.left)
                continue;
            CGContextMoveToPoint(ctx, point.x, point.y-3);
            CGContextAddLineToPoint(ctx, point.x, point.y);
            CGContextStrokePath(ctx);
        }
        
        for(CATextLayer *textLayer in xLabelLayers)
        {
            [textLayer removeFromSuperlayer];
        }
        for(CATextLayer *textLayer in yLabelLayers)
        {
            [textLayer removeFromSuperlayer];
        }
        [xLabelLayers removeAllObjects];
        [yLabelLayers removeAllObjects];
        [self showXLabels];
        [self showYLabels];
        
        UIGraphicsPopContext();
        
        [self strokeChart:NO duration:1.0];
    }
}


@end
