//
//  ScheduleTableViewCell.h
//  Centris
//

#import <UIKit/UIKit.h>

typedef enum ScheduleEventStateTypes {
    ScheduleEventHasNotBegan = 0,
    ScheduleEventHasBegan = 1,
    ScheduleEventHasFinished = 2
} ScheduleEventState;

@interface ScheduleTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *courseNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *fromTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *toTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeOfClassLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (nonatomic) ScheduleEventState scheduleEventState;
@end
