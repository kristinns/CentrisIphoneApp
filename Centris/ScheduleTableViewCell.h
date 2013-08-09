//
//  ScheduleTableViewCell.h
//  Centris
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *fromTime;
@property (weak, nonatomic) IBOutlet UILabel *toTime;
@property (weak, nonatomic) IBOutlet UIView *booking;
@property (weak, nonatomic) IBOutlet UILabel *bookingTitle;

@end
