//
//  WebViewController.h
//  Centris
//
//  Created by Kristinn Svansson on 20/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HTProgressHUD/HTProgressHUD.h>

@interface WebViewController : UIViewController
@property (nonatomic, strong) NSString *htmlContent;
@property (strong, nonatomic) HTProgressHUD *progressHud;
@property (nonatomic) BOOL showProgressHud;
@end
