//
//  PNChart.h
//	Version 0.1
//  PNChart
//
//  Created by kevin on 10/3/13.
//  Copyright (c) 2013年 kevinzhow. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PNChart.h"
#import "PNColor.h"
#import "PNLineChart.h"
#import "PNBarChart.h"
#import "PNCircleChart.h"

typedef enum {
	/** Solid line chart style */
	PNLineType,
	/** Bar chart style with bar background color  */
	PNBarType,
    /** Circle chart  */
    PNCircleType
	
} PNChartType;


@interface PNChart : UIView

/**
 * This method will call and troke the line in animation.
 */

-(void)strokeChart;

/**
 * X Labels will show on chart.
 *
 */

@property (strong, nonatomic) NSArray * xLabels;

/**
 * Y value for X label, Chart will generate the Y label by it self.
 *
 */

@property (strong, nonatomic) NSArray * yValues;

@property (strong, nonatomic) PNLineChart * lineChart;

@property (strong, nonatomic) PNBarChart * barChart;

@property (strong, nonatomic) PNCircleChart * circleChart;

/**
 * PNChart chart type. The default is PNLineChart.
 *
 * @see PNChartType
 */

@property (assign) PNChartType type;

/**
 * PNChart chart stroke color. The default is PNGreen.
 *
 */

@property (nonatomic, strong) UIColor * strokeColor;

/**
 * PNChart circle chart total number.
 *
 */

@property (nonatomic, strong) NSNumber * total;

/**
 * PNChart circle chart current number.
 *
 */
@property (nonatomic, strong) NSNumber * current;


@end
