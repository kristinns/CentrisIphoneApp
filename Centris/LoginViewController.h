//
//  LoginViewController.h
//  Centris
//
//  Created by Bjarki Sörens on 10/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LoginViewControllerDelegate <NSObject>
- (void)didFinishLoginWithValidUser;
@end

@interface LoginViewController : UIViewController
@property (nonatomic, weak) id<LoginViewControllerDelegate> delegate;
@end
