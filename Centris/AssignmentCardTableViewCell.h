//
//  AssignmentCardTableViewCell.h
//  Centris
//
//  Created by Kristinn Svansson on 26/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *timeUntilClosedLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseLabel;
@property (weak, nonatomic) IBOutlet UILabel *weightLabel;

@end
