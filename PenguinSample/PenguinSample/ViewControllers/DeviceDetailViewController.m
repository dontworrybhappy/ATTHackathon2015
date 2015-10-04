//
//  DeviceDetailViewController.m
//  PenguinSample
//
//  Created on 11/4/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "DeviceDetailViewController.h"
#import "DeviceLogViewController.h"
#import "DLDevice.h"

@interface DeviceDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *deviceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *deviceGuidLabel;
- (IBAction)viewDeviceActivityButtonTapped:(id)sender;
@end

@implementation DeviceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.device) {
        self.deviceNameLabel.text = self.device.deviceName;
        self.deviceGuidLabel.text = self.device.deviceGuid;
        self.deviceTypeLabel.text = self.device.deviceType;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)viewDeviceActivityButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceLogViewController *deviceLogViewControlelr = [mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceLogViewController"];
    deviceLogViewControlelr.device = self.device;

    [self.navigationController pushViewController:deviceLogViewControlelr animated:YES];
}
@end
