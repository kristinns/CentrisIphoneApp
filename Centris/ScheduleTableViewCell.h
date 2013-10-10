//
//  ScheduleTableViewCell.h
//  Centris
//

#import <UIKit/UIKit.h>

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;

@property (nonatomic) BOOL status;
@end
