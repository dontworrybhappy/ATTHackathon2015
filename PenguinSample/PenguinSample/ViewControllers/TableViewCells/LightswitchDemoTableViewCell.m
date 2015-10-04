//
//  LightswitchDemoTableViewCell.m
//  PenguinSample
//
//  Created on 11/6/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "LightswitchDemoTableViewCell.h"
#import "DLDevice.h"

@interface LightswitchDemoTableViewCell ()
{ int cellNo; }
- (IBAction)switchValueChanged:(id)sender;

@end


@implementation LightswitchDemoTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    static int nextCellNo = 0;
    cellNo = nextCellNo++;
}

- (void)setupCellWithDeviceInfo:(DLDevice *)device
{
    self.nameLabel.text = device.deviceName;
    self.currentStateLabel.text = device.attributes[@"switch"][@"value"];
    self.switchControl.on = [device.attributes[@"switch"][@"value"] isEqualToString:@"on"];
    self.device = device;
    
    if (device.pendingChangeLabel) {
        [self.spinner startAnimating];
        self.switchControl.enabled = NO;
    }
    else {
        [self.spinner stopAnimating];
        self.switchControl.enabled = YES;
    }
}


- (IBAction)switchValueChanged:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(switchValueChangedInCell:toValue:)]) {
        [self.delegate switchValueChangedInCell:self toValue:self.switchControl.on];
    }
}

@end
