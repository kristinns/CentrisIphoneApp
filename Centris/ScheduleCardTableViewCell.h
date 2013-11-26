//
//  ScheduleCardTableViewCell.h
//  Centris
//
//  Created by Kristinn Svansson on 24/11/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleCardTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeUntilLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end
