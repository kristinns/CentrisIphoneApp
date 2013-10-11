//
//  ScheduleTableViewCell.m
//  Centris
//

#import "ScheduleTableViewCell.h"

#define CIRCLE_POSITION_X 275
#define CIRCLE_POSITION_Y 19
#define TOP_BORDER_HEIGHT 1

@implementation ScheduleTableViewCell

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // Add border
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TOP_BORDER_HEIGHT)];
    topBorder.backgroundColor = [CentrisTheme grayLightColor];
    [self addSubview:topBorder];
    // Styling
    self.typeOfClassLabel.textColor = [CentrisTheme grayLightTextColor];
    self.fromTimeLabel.textColor = [CentrisTheme blackLightTextColor];
    self.toTimeLabel.textColor = [CentrisTheme grayLightTextColor];
    self.locationLabel.textColor = [CentrisTheme grayLightTextColor];
    self.courseNameLabel.textColor = [CentrisTheme blackLightTextColor];
    
    // Default not began
    self.scheduleEventState = ScheduleEventHasNotBegan;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setScheduleEventState:(ScheduleEventState)scheduleEventState
{
    _scheduleEventState = scheduleEventState;
    UIImageView *selectedImage;
    if (scheduleEventState == ScheduleEventHasNotBegan)
        selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-empty.png"]];
    else if (scheduleEventState == ScheduleEventHasBegan)
        selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-half.png"]];
    else if (scheduleEventState == ScheduleEventHasFinished)
        selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-full.png"]];
    
    selectedImage.frame = CGRectMake(CIRCLE_POSITION_X, CIRCLE_POSITION_Y, selectedImage.bounds.size.width, selectedImage.bounds.size.height);
    
    [self addSubview:selectedImage];
}

@end
