//
//  CourseInstanceTableViewCell.h
//  Centris
//
//  Created by Kristinn Svansson on 11/12/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CourseInstanceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradeDetailLabel;


@end
