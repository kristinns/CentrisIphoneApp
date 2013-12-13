//
//  PNLineChart.m
//  PNChartDemo
//
//  Created by kevin on 11/7/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import "PNLineChart.h"
#import "PNColor.h"
#import "PNChartLabel.h"
#define MAX_LABEL_WIDTH 40

@implementation PNLineChart

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
		_chartLine = [CAShapeLayer layer];
		_chartLine.lineCap = kCALineCapRound;
		_chartLine.lineJoin = kCALineJoinBevel;
		_chartLine.fillColor   = [[UIColor whiteColor] CGColor];
		_chartLine.lineWidth   = 3.0;
		_chartLine.strokeEnd   = 0.0;
		[self.layer addSublayer:_chartLine];
    }
    
    return self;
}

-(void)setYValues:(NSArray *)yValues
{
    _yValues = yValues;
    [self setYLabels:yValues];
}

-(void)setYLabels:(NSArray *)yLabels
{
    NSInteger max = 0;
    for (NSString * valueString in yLabels) {
        NSInteger value = [valueString integerValue];
        if (value > max) {
            max = value;
        }
        
    }
    
    //Min value for Y label
    if (max < 5) {
        max = 5;
    }
    
    _yValueMax = (int)max;
    
//    float level = max /[yLabels count];
//	
//    NSInteger index = 0;
//	NSInteger num = [yLabels count] + 1;
//	while (num > 0) {
//		CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2 - 40.0 ;
//		CGFloat levelHeight = chartCavanHeight /5.0;
//		PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(0.0,chartCavanHeight - index * levelHeight + (levelHeight - yLabelHeight) , 20.0, yLabelHeight)];
//		[label setTextAlignment:NSTextAlignmentRight];
//		label.text = [NSString stringWithFormat:@"%1.f",level * index];
//		[self addSubview:label];
//        index +=1 ;
//		num -= 1;
//	}

}

-(void)setXLabels:(NSArray *)xLabels
{
    _xLabels = xLabels;
    _xLabelWidth = (self.frame.size.width - chartMargin*2)/[xLabels count];
     _xLabelWidth = (_xLabelWidth < MAX_LABEL_WIDTH) ? _xLabelWidth : MAX_LABEL_WIDTH;
    
//    for (NSString * labelText in xLabels) {
//        NSInteger index = [xLabels indexOfObject:labelText];
//        PNChartLabel * label = [[PNChartLabel alloc] initWithFrame:CGRectMake(index * _xLabelWidth + 30.0, self.frame.size.height - 30.0, _xLabelWidth, 20.0)];
//        [label setTextAlignment:NSTextAlignmentCenter];
//        label.text = labelText;
//        [self addSubview:label];
//    }
    
}

-(void)setStrokeColor:(UIColor *)strokeColor
{
	_strokeColor = strokeColor;
	_chartLine.strokeColor = [strokeColor CGColor];
}

-(void)strokeChart
{
    UIGraphicsBeginImageContext(self.frame.size);
    
    UIBezierPath *progressline = [UIBezierPath bezierPath];
    
    CGFloat firstValue = [[_yValues objectAtIndex:0] floatValue];
    
    CGFloat xPosition = _xLabelWidth;
    
    CGFloat chartCavanHeight = self.frame.size.height - chartMargin * 2;
    
    float grade = (float)firstValue / (float)_yValueMax;
    [progressline moveToPoint:CGPointMake((chartMargin + xPosition * 0.5), chartCavanHeight - grade * chartCavanHeight+20)];//xPosition, chartCavanHeight - grade * chartCavanHeight - 10)];
    [progressline setLineWidth:3.0];
    [progressline setLineCapStyle:kCGLineCapRound];
    [progressline setLineJoinStyle:kCGLineJoinRound];
    NSInteger index = 0;
    for (NSString * valueString in _yValues) {
        NSInteger value = [valueString integerValue];
        
        float grade = (float)value / (float)_yValueMax;
        if (index != 0) {
            
//            [progressline addLineToPoint:CGPointMake(index * xPosition  + _xLabelWidth /2.0 + _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 10.0)];
//            
//            [progressline moveToPoint:CGPointMake(index * xPosition + _xLabelWidth /2.0 + _xLabelWidth /2.0, chartCavanHeight - grade * chartCavanHeight + 10.0 )];
            
//            float grade = (float)value / (float)_yValueMax;
//            
//            PNBar * bar = [[PNBar alloc] initWithFrame:CGRectMake((index *  _xLabelWidth + chartMargin + _xLabelWidth * 0.25), chartMargin, _xLabelWidth * 0.5, chartCavanHeight)];
            CGPoint nextPoint = CGPointMake((index * xPosition + chartMargin + xPosition * 0.5), chartCavanHeight - grade * chartCavanHeight+10);
            NSLog(@"%f, %f", nextPoint.x, nextPoint.y);
            [progressline addLineToPoint:nextPoint];
            [progressline moveToPoint:nextPoint];
            
            [progressline stroke];
        }
        if (index == [_yValues count]-1) {
            CGPoint nextPoint = CGPointMake(index * xPosition + chartMargin + xPosition, chartCavanHeight - grade * chartCavanHeight+10);
            [progressline addLineToPoint:nextPoint];
            [progressline moveToPoint:nextPoint];
        }
        
        index += 1;
    }
    
    _chartLine.path = progressline.CGPath;
	if (_strokeColor) {
		_chartLine.strokeColor = [_strokeColor CGColor];
	}else{
		_chartLine.strokeColor = [PNGreen CGColor];
	}
    
    
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    pathAnimation.duration = 1.0;
    pathAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    pathAnimation.fromValue = [NSNumber numberWithFloat:0.0f];
    pathAnimation.toValue = [NSNumber numberWithFloat:1.0f];
    pathAnimation.autoreverses = NO;
    [_chartLine addAnimation:pathAnimation forKey:@"strokeEndAnimation"];
    
    _chartLine.strokeEnd = 1.0;
    
    UIGraphicsEndImageContext();
}



@end
