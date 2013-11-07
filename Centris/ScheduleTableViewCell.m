//
//  ScheduleTableViewCell.m
//  Centris
//

#import "ScheduleTableViewCell.h"

#define CIRCLE_POSITION_X 275
#define CIRCLE_POSITION_Y 19
#define TOP_BORDER_HEIGHT 1
#define SEPERATOR_HEIGHT 26.0
#define ROW_HEIGHT 61.0

@interface ScheduleTableViewCell()
@property (nonatomic, strong) UIView *topBorder;
@property (nonatomic, strong) UIView *seperatorView;
@property (nonatomic, strong) UIImageView *selectedImageView;
@property (nonatomic, strong) UILabel *seperatorLabel;
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

- (void)prepareForReuse
{
    [self.seperatorLabel removeFromSuperview];
    [self.seperatorView removeFromSuperview];
    self.seperatorView = nil;
    self.seperatorLabel = nil;
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
    self.fromTimeLabel.textColor = [CentrisTheme redColor];
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
    //[super setSelected:selected animated:animated];

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
    [self.selectedImageView removeFromSuperview];
    if (scheduleEventState == ScheduleEventHasNotBegan)
        self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-empty.png"]];
    else if (scheduleEventState == ScheduleEventHasBegan)
        self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-half.png"]];
    else if (scheduleEventState == ScheduleEventHasFinished)
        self.selectedImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-full.png"]];
    
    self.selectedImageView.frame = CGRectMake(CIRCLE_POSITION_X, CIRCLE_POSITION_Y, self.selectedImageView.bounds.size.width, self.selectedImageView.bounds.size.height);
    [self addSubview:self.selectedImageView];
}

- (void)setSeperatorBreakText:(NSString *)seperatorBreakText
{
    if (self.bounds.size.height > 87)
        self.bounds = CGRectMake(self.bounds.origin.x, self.bounds.origin.y, self.bounds.size.width, ROW_HEIGHT+SEPERATOR_HEIGHT);
    NSLog(@"%@ - %f", seperatorBreakText, self.bounds.size.height);
    if (!_seperatorBreakText) {
        //if (self.bounds.size.height == 87) {
            self.seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height-SEPERATOR_HEIGHT, self.bounds.size.width, SEPERATOR_HEIGHT)];
            self.seperatorView.backgroundColor = [CentrisTheme grayLightColor];
            self.seperatorLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.bounds.size.width, SEPERATOR_HEIGHT)];
            self.seperatorLabel.text = seperatorBreakText;
            self.seperatorLabel.textColor = [CentrisTheme grayLightTextColor];
            self.seperatorLabel.font = [CentrisTheme headingSmallFont];
            [self.seperatorView addSubview:self.seperatorLabel];
            [self addSubview:self.seperatorView];
       // }
    } else {
        self.seperatorLabel.text = seperatorBreakText;
    }
}

@end
