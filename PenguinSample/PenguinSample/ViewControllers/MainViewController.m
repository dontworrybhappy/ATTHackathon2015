//
//  MainViewController.m
//  PenguinSample
//
//  Created on 11/5/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "MainViewController.h"
#import "DeviceListViewController.h"
#import "ProgramListViewController.h"
#import "eServiceLogViewController.h"
#import "LightswitchDemoViewController.h"

@interface MainViewController ()
- (IBAction)deviceListButtonTapped:(id)sender;
- (IBAction)programListButtonTapped:(id)sender;
- (IBAction)viewEServiceLogButtonTapped:(id)sender;
- (IBAction)lightSwitchDemoButtonTapped:(id)sender;



@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (IBAction)deviceListButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceListViewController *deviceListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"deviceListViewController"];
    [self.navigationController pushViewController:deviceListVC animated:YES];
}

- (IBAction)programListButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProgramListViewController *programListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProgramListViewController"];
    [self.navigationController pushViewController:programListVC animated:YES];
}

- (IBAction)viewEServiceLogButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    eServiceLogViewController *eServiceListVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"eServiceLogViewController"];
    [self.navigationController pushViewController:eServiceListVC animated:YES];
}

- (IBAction)lightSwitchDemoButtonTapped:(id)sender {
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    LightswitchDemoViewController *lightswitchDemoVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"LightswitchDemoViewController"];
    [self.navigationController pushViewController:lightswitchDemoVC animated:YES];
}
@end
