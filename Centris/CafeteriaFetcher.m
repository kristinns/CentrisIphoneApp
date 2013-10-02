//
//  CafeteriaFetcher.m
//  Centris
//
//  Created by Bjarki Sörens on 9/26/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "CafeteriaFetcher.h"
#import "HTMLNode.h"
#import "HTMLParser.h"

#define CAFETERIA_URL @"http://malid.ru.is"

@implementation CafeteriaFetcher
+(NSArray *)getMenu
{
	NSArray *menu = nil;
	
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@",CAFETERIA_URL]];
	
	NSError *error;
	NSString *html = [NSString stringWithContentsOfURL:url encoding:4 error:&error];
	if (error) {
		NSLog(@"Error: %@", [error userInfo]);
	}
	
	HTMLParser *parser = [[HTMLParser alloc] initWithString:html error:&error];
	if (error) {
		NSLog(@"Error: %@", [error userInfo]);
	}
	
	HTMLNode *bodyNode = [parser body];
//	NSArray *menu = [bodyNode findChildrenOfClass:@"storycontent"];

	for (HTMLNode *item in [[bodyNode findChildOfClass:@"storycontent"] children]) {
		if ([item findChildTag:@"strong"]) {
			NSLog(@"%@", [[item findChildTag:@"strong"] rawContents]);
			while ([[item nextSibling] findChildTag:@"p"]) {
				NSLog(@"%@", [[item findChildTag:@"p"] rawContents]);
			}
		}
	}
	
	
	return menu;
}
@end
