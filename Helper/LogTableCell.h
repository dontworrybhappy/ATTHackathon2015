//
//  LogTableCell.h
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/3/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LogTableCell : UITableViewCell

@property (strong, nonatomic) UILabel *date;
@property (strong, nonatomic) UILabel *bloodSugar;
@property (strong, nonatomic) UILabel *carbs;
@property (strong, nonatomic) UILabel *insulin;


@property (strong, nonatomic) UIView *divider1;
@property (strong, nonatomic) UIView *divider2;

@property (strong, nonatomic) UIView *divider3;


@end

