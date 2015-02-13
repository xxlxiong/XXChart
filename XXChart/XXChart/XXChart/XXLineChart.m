//
//  XXLineChart.m
//  XXChart
//
//  Created by NYZ Star on 8/20/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import "XXLineChart.h"
#import "XXLineChartData.h"
#import "XXColors.h"
@implementation XXLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        conentLayer = [CAShapeLayer new];
        [self.layer addSublayer:conentLayer];
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
    isReDrawContent = YES;
    
    _isAllowPointSelect = YES;
    _isFill = YES;
    _selectPointColor = [UIColor redColor];
    _pointRadius = 1.;
    //据四周默认为20
    _chartMargin.top=20;
    _chartMargin.bottom = 20;
    _chartMargin.left=20;
    _chartMargin.right=20;
    
    pathPoints = [[NSMutableArray alloc] init];
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

-(void)setXLabels:(NSArray *)xLabels originIndex:(NSUInteger)arrayIndex
{
    [self setXLabels:xLabels];
    xOriginPoint.x -= _xUnitDis*arrayIndex;
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
            textLayer.frame = CGRectMake(yOriginPoint.x-5-_chartMargin.left, yOriginPoint.y+yAxisLength-i*_yUnitDis-7, _chartMargin.left, 15);
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

-(void)setChartData:(NSArray *)chartData
{
    // remove all shape layers before adding new ones
    for (CALayer *layer in chartLineArray) {
        [layer removeFromSuperlayer];
    }
    for (CALayer *layer in chartPointArray) {
        [layer removeFromSuperlayer];
    }
    chartLineArray = [NSMutableArray arrayWithCapacity:chartData.count];
    chartPointArray= [NSMutableArray arrayWithCapacity:chartData.count];
    
    for(XXLineChartData *lineChartData in chartData){
        CAShapeLayer *chartLine = [CAShapeLayer layer];
        chartLine.lineCap       = kCALineCapButt;
        chartLine.lineJoin      = kCALineJoinMiter;
        chartLine.fillColor     = [[UIColor whiteColor] CGColor];
        chartLine.lineWidth     = lineChartData.lineWidth;
        chartLine.strokeEnd     = 0.0;
        [self.layer addSublayer:chartLine];
        [chartLineArray addObject:chartLine];
        
        // create point
        CAShapeLayer *pointLayer = [CAShapeLayer layer];
        pointLayer.strokeColor   = [lineChartData.color CGColor];
        pointLayer.lineCap       = kCALineCapRound;
        pointLayer.lineJoin      = kCALineJoinBevel;
        pointLayer.fillColor     = nil;
        pointLayer.lineWidth     = lineChartData.lineWidth;
        [self.layer addSublayer:pointLayer];
        [chartPointArray addObject:pointLayer];
        
    }
    _chartData = chartData;
}
//画出图形
-(void)strokeChart:(BOOL)isAnimation duration:(NSTimeInterval)duration
{
    if(!chartPath)
        chartPath = [NSMutableArray array];
    if(!pointPath)
        pointPath = [NSMutableArray array];
    [pathPoints removeAllObjects];
    xBeginIndex = 0;
    //draw each line
    for(NSUInteger lineIndex = 0;lineIndex<_chartData.count;lineIndex++)
    {
        XXLineChartData *lineChartData = _chartData[lineIndex];
        CAShapeLayer *chartLine = (CAShapeLayer *)chartLineArray[lineIndex];
        CAShapeLayer *pointLayer = (CAShapeLayer *)chartPointArray[lineIndex];
        
        CGFloat yValue;
        CGFloat innerGrade;
        
        UIGraphicsBeginImageContext(self.frame.size);
        
        UIBezierPath *progressline = [UIBezierPath bezierPath];
        [progressline setLineWidth:lineChartData.lineWidth];
        [progressline setLineCapStyle:kCGLineCapRound];
        [progressline setLineJoinStyle:kCGLineJoinRound];
        
        UIBezierPath *pointPaths = [UIBezierPath bezierPath];
        [pointPaths setLineWidth:lineChartData.lineWidth];
        
        [chartPath addObject:progressline];
        [pointPath addObject:pointPaths];
        
        NSMutableArray *linePointsArray = [NSMutableArray array];
        
        int last_x = 0;
        int last_y = 0;
        CGFloat inflexionWidth = lineChartData.inflexionPointWidth;
        
        for (NSUInteger i = 0; i < lineChartData.dataArray.count; i++) {
            yValue = [lineChartData.dataArray[i] floatValue];
            
            if (!(yValueMax - yValueMin)) {
                innerGrade = 0.5;
            } else {
                innerGrade = (yValue - yValueMin) / (yValueMax - yValueMin);
            }
            
            //计算画的点的坐标
            int x = xOriginPoint.x +  (i * _xUnitDis);
            int y = xOriginPoint.y -  yValue * canvanHeight;
            
            if (x<_chartMargin.left) {
                last_x = x;
                last_y = y;
                xBeginIndex++;
                continue;
            }else if (last_x<_chartMargin.left)
            {
                //求交点
                last_y = (y-last_y)/(x-last_x)*(_chartMargin.left-last_x)+last_y;
                last_x = x==_chartMargin.left?_chartMargin.left-1:_chartMargin.left;
            }
            // cycle style point
            if(lineChartData.inflexionPointStyle == LineChartPointStyleCycle)
            {
//                CGRect circleRect = CGRectMake(x-inflexionWidth/2, y-inflexionWidth/2, inflexionWidth,inflexionWidth);
                CGPoint circleCenter = CGPointMake(x, y);
                
                [pointPaths moveToPoint:CGPointMake(circleCenter.x + (inflexionWidth/2), circleCenter.y)];
                [pointPaths addArcWithCenter:circleCenter radius:inflexionWidth/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (inflexionWidth/2) / distance * (x-last_x);
                    float last_y1 = last_y + (inflexionWidth/2) / distance * (y-last_y);
                    float x1 = x - (inflexionWidth/2) / distance * (x-last_x);
                    float y1 = y==last_y?y:y - (inflexionWidth/2) / distance * (y-last_y);
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                }
                last_x = x;
                last_y = y;
            }
            // Square style point
            else if (lineChartData.inflexionPointStyle == LineChartPointStyleSquare){
                CGRect squareRect = CGRectMake(x-inflexionWidth/2, y-inflexionWidth/2, inflexionWidth,inflexionWidth);
                CGPoint squareCenter = CGPointMake(squareRect.origin.x + (squareRect.size.width / 2), squareRect.origin.y + (squareRect.size.height / 2));
                
                [pointPaths moveToPoint:CGPointMake(squareCenter.x - (inflexionWidth/2), squareCenter.y - (inflexionWidth/2))];
                [pointPaths addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth/2), squareCenter.y - (inflexionWidth/2))];
                [pointPaths addLineToPoint:CGPointMake(squareCenter.x + (inflexionWidth/2), squareCenter.y + (inflexionWidth/2))];
                [pointPaths addLineToPoint:CGPointMake(squareCenter.x - (inflexionWidth/2), squareCenter.y + (inflexionWidth/2))];
                [pointPaths closePath];
                
                if ( i != 0 ) {
                    
                    // calculate the point for line
                    float distance = sqrt( pow(x-last_x, 2) + pow(y-last_y,2) );
                    float last_x1 = last_x + (inflexionWidth/2);
                    float last_y1 = last_y + (inflexionWidth/2) / distance * (y-last_y);
                    float x1 = x - (inflexionWidth/2);
                    float y1 = y==last_y?y:(y - (inflexionWidth/2) / distance * (y-last_y));
                    
                    [progressline moveToPoint:CGPointMake(last_x1, last_y1)];
                    [progressline addLineToPoint:CGPointMake(x1, y1)];
                }
                
                last_x = x;
                last_y = y;
            }
            // Triangle style point
            else if (lineChartData.inflexionPointStyle == LineChartPointStyleTriangle) {
                
                if ( i != 0 ) {
                    [progressline addLineToPoint:CGPointMake(x, y)];
                }
                
                [progressline moveToPoint:CGPointMake(x, y)];
            } else {
                
                if ( i != 0 ) {
                    [progressline addLineToPoint:CGPointMake(x, y)];
                }
                
                [progressline moveToPoint:CGPointMake(x, y)];
            }
            
            [linePointsArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        }
        [pathPoints addObject:[linePointsArray copy]];
        
        // setup the color of the chart line
        if (lineChartData.color) {
            chartLine.strokeColor = [lineChartData.color CGColor];
        }
        else {
            chartLine.strokeColor = [PNGreen CGColor];
            pointLayer.strokeColor = [PNGreen CGColor];
        }
        
        [progressline stroke];
        
        chartLine.path = progressline.CGPath;
        pointLayer.path = pointPaths.CGPath;
        
        if(isAnimation)     //start animation
        {
            [CATransaction begin];
            CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
            pathAnimation.duration = duration;
            pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            pathAnimation.fromValue = @0.0f;
            pathAnimation.toValue   = @1.0f;
            
            [chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            chartLine.strokeEnd = 1.0;
            
            // if you want cancel the point animation, conment this code, the point will show immediately
            if (lineChartData.inflexionPointStyle != LineChartPointStyleNone) {
                [pointLayer addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
            }
            
            [CATransaction setCompletionBlock:^{
                //pointLayer.strokeEnd = 1.0f; // stroken point when animation end
            }];
            [CATransaction commit];
        }
        
        UIGraphicsEndImageContext();
    }
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
        [self showSelectPoint:LineChartPointStyleCycle];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    pTouchPoint = touchPoint;
    
    for (NSInteger p = pathPoints.count - 1; p >= 0; p--) {
        NSArray *linePointsArray = pathPoints[p];
        
        for (int i = 0; i < linePointsArray.count - 1; i += 1) {
            CGPoint p1 = [linePointsArray[i] CGPointValue];
            CGPoint p2 = [linePointsArray[i + 1] CGPointValue];
            
            float distanceToP1 = fabsf(hypot(touchPoint.x - p1.x, touchPoint.y - p1.y));
            float distanceToP2 = hypot(touchPoint.x - p2.x, touchPoint.y - p2.y);
            
            float distance = MIN(distanceToP1, distanceToP2);
            
            if (distance <= 10.0) {
                [_delegate userClickedOnLineKeyPoint:touchPoint
                                           lineIndex:p
                                       andPointIndex:xBeginIndex+(distance == distanceToP2 ? i + 1 : i)];
                if(_isAllowPointSelect)
                {
                    selectedPoint = (distance == distanceToP2)?p2:p1;
                    selectedPoint.x = selectedPoint.x-xOriginPoint.x+_chartMargin.left;
                    [self showSelectPoint:LineChartPointStyleCycle];
                }
                return;
            }
        }
    }
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if(!_ScrollEnable)
        return;
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    xMoveDistance = touchPoint.x - pTouchPoint.x;
    float ydistance = touchPoint.y - pTouchPoint.y;
    conentLayer.frame = CGRectMake(conentLayer.frame.origin.x+xMoveDistance, conentLayer.frame.origin.y+ydistance, conentLayer.frame.size.width, conentLayer.frame.size.height);
    
    xOriginPoint.x += xMoveDistance;
    if(xOriginPoint.x>_chartMargin.left)
        xOriginPoint.x = _chartMargin.left;
    if(xOriginPoint.x+_xUnitDis*_xLabels.count<CGRectGetWidth(self.frame)-_chartMargin.right)
        xOriginPoint.x -= xMoveDistance;
    
    pTouchPoint = touchPoint;
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    pTouchPoint = CGPointZero;
}

//select point show
- (void)showSelectPoint:(LineChartPointStyle)pointStyle
{
    if (_isAllowPointSelect) {
        UIGraphicsBeginImageContext(self.frame.size);
        
        if(!selectShowLayer)
        {
            selectShowLayer = [CAShapeLayer layer];
            selectShowLayer.strokeColor = _selectPointColor.CGColor;
            selectShowLayer.fillColor     = _isFill?_selectPointColor.CGColor:nil;
            selectShowLayer.lineWidth     = _pointRadius;
            [self.layer addSublayer:selectShowLayer];
        }
        
        CGPoint showPoint = CGPointMake(selectedPoint.x+xOriginPoint.x-_chartMargin.left, selectedPoint.y);
        if(showPoint.x<_chartMargin.left)
            selectShowLayer.path = nil;
        else
        {
            UIBezierPath *selectPath = [UIBezierPath bezierPath];
            
            if(pointStyle == LineChartPointStyleCycle)
            {
                [selectPath addArcWithCenter:showPoint radius:5.0/2 startAngle:0 endAngle:2*M_PI clockwise:YES];
            }
            [selectPath stroke];
            selectShowLayer.path = selectPath.CGPath;
        }
        UIGraphicsEndImageContext();
    }
}

@end
