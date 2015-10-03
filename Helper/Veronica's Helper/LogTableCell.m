//
//  LogTableCell.m
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/3/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
//

#import "LogTableCell.h"



@implementation LogTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (UILabel *)label {
    UILabel *label = [[UILabel alloc] init];
    label.translatesAutoresizingMaskIntoConstraints = NO;
    [self.contentView addSubview:label];
    return label;
}

- (UIView *)divider {
    UIView *view = [[UIView alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    [view addConstraint:[NSLayoutConstraint constraintWithItem:view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:1.0/[[UIScreen mainScreen] scale]]];
    view.backgroundColor = [UIColor lightGrayColor];
    [self.contentView addSubview:view];
    return view;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.separatorInset = UIEdgeInsetsZero;
    self.layoutMargins = UIEdgeInsetsZero;
    self.preservesSuperviewLayoutMargins = NO;
    
    self.divider1 = [self divider];
    self.divider2 = [self divider];
    self.divider3 = [self divider];
    
    self.date = [self label];
    self.bloodSugar = [self label];
    self.carbs = [self label];
    self.insulin = [self label];
    
    NSDictionary *views = NSDictionaryOfVariableBindings(_date, _bloodSugar, _carbs, _insulin, _divider1, _divider2, _divider3);
    
   /* NSArray *constraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-5-[_date]-2-[_divider1]-2-[_bloodsugar(==_date)]-2-[_divider2]-2-[_carbs(==_date)]-5-|" options:NSLayoutFormatAlignAllCenterY metrics:nil views:views];
    [self.contentView addConstraints:constraints];
    
    NSArray *horizontalConstraints1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider1]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints1];
    NSArray *horizontalConstraints2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_divider2]|" options:0 metrics:nil views:views];
    [self.contentView addConstraints:horizontalConstraints2];
    */
    return self;
}


@end
