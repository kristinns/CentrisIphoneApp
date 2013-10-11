//
//  ScheduleTableViewCell.m
//  Centris
//

#import "ScheduleTableViewCell.h"

#define CIRCLE_POSITION_X 275
#define CIRCLE_POSITION_Y 19
#define TOP_BORDER_HEIGHT 1

@interface ScheduleTableViewCell()
@property (nonatomic, strong) UIView *topBorder;
@end

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
    self.topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, TOP_BORDER_HEIGHT)];
    self.topBorder.backgroundColor = [CentrisTheme grayLightColor];
    [self addSubview:self.topBorder];
    // Styling
    self.typeOfClassLabel.textColor = [CentrisTheme grayLightTextColor];
    self.typeOfClassLabel.font = [CentrisTheme headingSmallFont];
    self.fromTimeLabel.textColor = [CentrisTheme blackLightTextColor];
    self.fromTimeLabel.font = [CentrisTheme headingMediumFont];
    self.toTimeLabel.textColor = [CentrisTheme grayLightTextColor];
    self.toTimeLabel.font = [CentrisTheme headingSmallFont];
    self.locationLabel.textColor = [CentrisTheme grayLightTextColor];
    self.locationLabel.font = [CentrisTheme headingSmallFont];
    self.courseNameLabel.textColor = [CentrisTheme blackLightTextColor];
    self.courseNameLabel.font = [CentrisTheme headingMediumFont];
    
    // Default not began
    self.scheduleEventState = ScheduleEventHasNotBegan;
    self.topBorderIsHidden = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTopBorderIsHidden:(BOOL)topBorderIsHidden
{
    _topBorderIsHidden = topBorderIsHidden;
    self.topBorder.hidden = topBorderIsHidden;
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
