//
//  LogTableViewController.h
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/3/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
///Users/patriciahale/Desktop/Veronica's Helper/Veronica's Helper/LogTableViewController.h

#import <UIKit/UIKit.h>

@interface LogTableViewController : UIViewController

@interface MultiColumnTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *Date;
@property (strong, nonatomic) UILabel *Blood Sugar;
@property (strong, nonatomic) UILabel *Carbs;
@property (strong, nonatomic) UILabel *Insulin;
@end


@end
