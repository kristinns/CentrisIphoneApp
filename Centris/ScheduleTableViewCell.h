//
//  ScheduleTableViewCell.h
//  Centris
//
//  Created by Kristinn Svansson on 8/4/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fromTime;
@property (weak, nonatomic) IBOutlet UILabel *toTime;

@end
