//
//  AssignmentTableViewCell.h
//  Centris
//
//  Created by Kristinn Svansson on 10/22/13.
//  Copyright (c) 2013 Kristinn Svansson. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum AssignmentEventState {
    AssignmentIsFinished = 0,
    AssignmentIsNotFinished = 1
} AssignmentEventState;

@interface AssignmentTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailUpperLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailLowerLabel;
@property (nonatomic) AssignmentEventState assignmentEventState;
@property (nonatomic) BOOL topBorderIsHidden;
@end
