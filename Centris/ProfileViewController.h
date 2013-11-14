//
//  ProfileViewController.h
//  Centris
//
//  Created by Bjarki Sörens on 14/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ProfileViewControllerDelegate <NSObject>
- (void)didLogOutUser;
@end

@interface ProfileViewController : UIViewController
@end
