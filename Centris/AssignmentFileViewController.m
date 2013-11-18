//
//  AssignmentFileViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentFileViewController.h"

@interface AssignmentFileViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation AssignmentFileViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setup];
}

- (void)setup
{
    self.navigationController.navigationBar.backItem.title = @"Verkefni";
    self.webView.scrollView.scrollEnabled = YES;
    // This should of course use AFNetworking and be in DataFetcher
    NSURL *targetURL = [NSURL URLWithString:@"http://developer.apple.com/iphone/library/documentation/UIKit/Reference/UIWebView_Class/UIWebView_Class.pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webView loadRequest:request];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
