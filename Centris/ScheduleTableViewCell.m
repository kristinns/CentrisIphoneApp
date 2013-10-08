//
//  ScheduleTableViewCell.m
//  Centris
//

#import "ScheduleTableViewCell.h"

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
    UIView *topBorder = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 1)];
    topBorder.backgroundColor = [UIColor colorWithRed:244.0/255.0 green:236.0/255.0 blue:237.0/255.0 alpha:1.0];
    
    UIImageView *selectedImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"selected-circle-empty.png"]];
    selectedImage.frame = CGRectMake(275, 19, selectedImage.bounds.size.width, selectedImage.bounds.size.height);
    
    [self addSubview:selectedImage];
    [self addSubview:topBorder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
