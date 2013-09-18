//
//  CentrisTheme.m
//  Centris
//
//	Handles all the theme styles for the app
//
//  Created by Bjarki Sörens on 9/18/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CentrisTheme.h"

@implementation CentrisTheme
+ (UIColor *)sideMenuBackgroundColor {
	return [UIColor colorWithRed:76.0/255.0 green:76.0/255.0 blue:78.0/255.0 alpha:1.0]; // Centris navigation grey
}

+ (UIColor *)sideMenuSelectedRowColor {
	return [UIColor colorWithRed:219.0/255.0 green:46.0/255.0 blue:53.0/255.0 alpha:1.0]; // Centris red
}
@end
