//
//  XXPieChart.m
//  XXChart
//
//  Created by NYZ Star on 8/22/14.
//  Copyright (c) 2014 NYZ Star. All rights reserved.
//

#import "XXPieChart.h"

@implementation XXPieChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _outterCircleRadius = CGRectGetWidth(self.bounds)/2;
		_innerCircleRadius  = CGRectGetWidth(self.bounds)/6;
		
		_descriptionTextColor = [UIColor whiteColor];
		_descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
        _descriptionTextShadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _descriptionTextShadowOffset =  CGSizeMake(0, 1);
        
		[self loadDefault];
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame items:(NSArray *)items{
	self = [self initWithFrame:frame];
	if(self){
		_items = [NSArray arrayWithArray:items];
		_outterCircleRadius = CGRectGetWidth(self.bounds)/2;
		_innerCircleRadius  = CGRectGetWidth(self.bounds)/6;
		
		_descriptionTextColor = [UIColor whiteColor];
		_descriptionTextFont  = [UIFont fontWithName:@"Avenir-Medium" size:18.0];
        _descriptionTextShadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        _descriptionTextShadowOffset =  CGSizeMake(0, 1);
        
		[self loadDefault];
	}
	
	return self;
}

-(void)loadDefault
{
	total       = 0;
    
    [descriptionLabels removeAllObjects];
	descriptionLabels = [NSMutableArray new];
    piePaths = [NSMutableArray array];
    
}

-(void)setItems:(NSArray *)items
{
    _items = items;
    total = 0;
}

#pragma mark - 
-(void)strokeChart:(BOOL)animation duration:(NSTimeInterval)duration
{
    if(piePaths)
        [piePaths removeAllObjects];
    if(pieLayer)
        [pieLayer removeFromSuperlayer];
    pieLayer = [CAShapeLayer layer];
    center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    [self.layer addSublayer:pieLayer];
    
    [self.items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		total +=((XXPieChartData *)obj).value;
	}];
    float currentValue=0;
    for(XXPieChartData *pieChartData in _items)
    {
        float startPercentage =  currentValue/total;
        float endPercentage   = (currentValue + pieChartData.value)/total;
        
        CAShapeLayer *currentPieLayer = [self newArcLayerWithRadius:_innerCircleRadius + (_outterCircleRadius - _innerCircleRadius)/2 borderWidth:_outterCircleRadius - _innerCircleRadius fillColor:[UIColor clearColor] borderColor:pieChartData.color startPercentage:startPercentage endPercentage:endPercentage isMask:NO];
        
        [pieLayer addSublayer:currentPieLayer];
        currentValue += pieChartData.value;
    }
    [self maskChart:animation duration:duration];
}

//遮罩，用来显示动画
-(void)maskChart:(BOOL)animation duration:(NSTimeInterval)duration
{
    CAShapeLayer *maskLayer = [self newArcLayerWithRadius:_innerCircleRadius + (_outterCircleRadius - _innerCircleRadius)/2 borderWidth:_outterCircleRadius - _innerCircleRadius fillColor:[UIColor clearColor] borderColor:[UIColor blackColor] startPercentage:0 endPercentage:2 isMask:YES];
	
	pieLayer.mask = maskLayer;
	CABasicAnimation *Animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
	Animation.duration  = duration;
	Animation.fromValue = @0;
	Animation.toValue   = @1;
    Animation.delegate  = self;
	Animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	Animation.removedOnCompletion = YES;
	[maskLayer addAnimation:Animation forKey:@"circleAnimation"];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
#pragma mark - cicledraw
-(CAShapeLayer*)newArcLayerWithRadius:(float)radius    borderWidth:(float)borderWidth fillColor:(UIColor*)fillColor    borderColor:(UIColor *)borderColor
                      startPercentage:(CGFloat)startPercentage                    endPercentage:(CGFloat)endPercentage    isMask:(BOOL)isMask
{
    CAShapeLayer *circle = [CAShapeLayer layer];
//    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds),CGRectGetMidY(self.bounds));
    UIBezierPath *ciclePath = [UIBezierPath bezierPathWithArcCenter:center radius:radius startAngle:-M_PI_2+M_PI*2*startPercentage endAngle:-M_PI_2+M_PI*2*endPercentage clockwise:YES];
    
    circle.fillColor   = fillColor.CGColor;
    circle.strokeColor = borderColor.CGColor;
    circle.lineWidth   = borderWidth;
    circle.path        = ciclePath.CGPath;
    if(!isMask)
    {
        UIBezierPath *_ciclePath = [UIBezierPath bezierPathWithArcCenter:center radius:_outterCircleRadius startAngle:-M_PI_2+M_PI*2*startPercentage endAngle:-M_PI_2+M_PI*2*endPercentage clockwise:YES];
       [piePaths addObject:_ciclePath];
    }
    return circle;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    for(NSUInteger i=0;i<piePaths.count;i++)
    {
        UIBezierPath *_piePath = piePaths[i];
        if ([_piePath containsPoint:touchPoint]&& [_delegate respondsToSelector:@selector(userClickedOnPieCharIndex:)]) {
            [_delegate userClickedOnPieCharIndex:i];
        }
    }

}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    NSLog(@"stop");
    //封闭弧形，便于点击检测
    for(NSUInteger i=0;i<piePaths.count;i++)
    {
        UIBezierPath *_piePath = piePaths[i];
        [_piePath addLineToPoint:center];
        [_piePath closePath];
    }
}

@end
