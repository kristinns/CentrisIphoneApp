//
//  AssignmentFileViewController.m
//  Centris
//
//  Created by Kristinn Svansson on 18/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import "AssignmentFileViewController.h"
#import "AppFactory.h"
#import <HTProgressHUD/HTProgressHUD.h>

@interface AssignmentFileViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) HTProgressHUD *HUD;

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
    self.HUD = [[HTProgressHUD alloc] init];
    self.HUD.text = @"Sæki skrá..";
    [self.HUD showInView:self.view];
    self.navigationController.navigationBar.backItem.title = @"Verkefni";
    self.webView.scrollView.scrollEnabled = YES;
    // This should of course use AFNetworking and be in DataFetcher
    NSURL *targetURL = [NSURL URLWithString:self.url];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:targetURL];
    NSString *user = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecAttrAccount)];
    NSString *password = [[AppFactory keychainItemWrapper] objectForKey:(__bridge id)(kSecValueData)];
    NSString *basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", user, password];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", AFBase64EncodedStringFromString(basicAuthCredentials)];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    [self.webView loadRequest:request];
    [self.HUD hide];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

static NSString * AFBase64EncodedStringFromString(NSString *string) {
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

@end
