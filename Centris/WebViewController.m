//
//  WebViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 20/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation WebViewController
#pragma mark - Properties
- (void)setHtmlContent:(NSString *)htmlContent
{
    _htmlContent = htmlContent;
    [self.webView loadHTMLString:self.htmlContent baseURL:nil];
}
#pragma mark - UIViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.webView loadHTMLString:self.htmlContent baseURL:nil];
    if (self.showProgressHud) {
        self.progressHud = [[HTProgressHUD alloc] init];
        self.progressHud.text = [@"Sæki " stringByAppendingString:self.title];
        [self.progressHud showInView:self.view];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
