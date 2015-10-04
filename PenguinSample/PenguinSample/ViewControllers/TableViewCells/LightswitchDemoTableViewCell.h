//
//  LightswitchDemoTableViewCell.h
//  PenguinSample
//
//  Created on 11/6/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LightswitchDemoTableViewCell;

@protocol LightswitchDemoTableViewCellDelegate <NSObject>
- (void)switchValueChangedInCell:(LightswitchDemoTableViewCell *)cell toValue:(BOOL)value;
@end

@class DLDevice;

@interface LightswitchDemoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentStateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchControl;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (weak, nonatomic) id <LightswitchDemoTableViewCellDelegate> delegate;
@property (nonatomic,strong) DLDevice *device;
- (void)setupCellWithDeviceInfo:(DLDevice *)device;

@end
