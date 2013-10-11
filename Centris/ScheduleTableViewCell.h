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
@property (nonatomic, weak) IBOutlet UILabel *courseNameLabel;
@property (nonatomic, weak) IBOutlet UILabel *fromTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *toTimeLabel;
@property (nonatomic, weak) IBOutlet UILabel *typeOfClassLabel;
@property (nonatomic, weak) IBOutlet UILabel *locationLabel;
@property (nonatomic) ScheduleEventState scheduleEventState;
@property (nonatomic) BOOL topBorderIsHidden;
@end
