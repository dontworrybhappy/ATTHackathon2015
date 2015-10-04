//
//  LightswitchDemoViewController.m
//  PenguinSample
//
//  Created on 11/5/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

/*********************************************************************************/
/*                                                                               */
/* How to turn lights on and off:                                                */
/*                                                                               */
/*   1) call the /devices api call, passing "swtich" for label and the desired   */
/*       "on"/"off" value (see the switchValueChangedInCell: method below)       */
/*   2) watch for confirmation of the change on eService (in this case we are    */
/*       ar
/*                                                                               */
/*********************************************************************************/

#import "LightswitchDemoViewController.h"
#import "DLClient.h"
#import "DLDevice.h"
#import "LightswitchDemoTableViewCell.h"

@interface LightswitchDemoViewController () <LightswitchDemoTableViewCellDelegate>
- (IBAction)allOnButtonTapped:(id)sender;
- (IBAction)allOffButtonTapped:(id)sender;
- (IBAction)toggleAllButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *lightswitchDevices;
@end

@implementation LightswitchDemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    // find all the light switch devices
    NSMutableArray *lightSwitchDevices = [[NSMutableArray alloc] init];
    NSArray *allDevices = [[DLClient shared] devices];
    for (DLDevice *device in allDevices) {
        if (([device.deviceType isEqualToString:@"light-control"] && device.attributes[@"switch"] != nil)) { // 
            [lightSwitchDevices addObject:device];
        }
    }
    
    // save a non-mutable copy
    self.lightswitchDevices = [lightSwitchDevices copy];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:@"DeviceUpdated" object:nil queue:nil usingBlock:^(NSNotification *note) {
        // by the time we get here, the devices have already been updated, so just reload the table
        DLDevice *device = note.userInfo[@"device"];
        NSInteger deviceIndex = [self.lightswitchDevices indexOfObject:device];
        if (deviceIndex != NSNotFound) {
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForItem:deviceIndex inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:nil name:@"DeviceUpdated" object:nil];
}

#pragma mark - TableView Data Source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.lightswitchDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LightswitchDemoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"lightswitchDemoCell"];
    DLDevice *lightcontrol = self.lightswitchDevices[indexPath.row];

    [cell setupCellWithDeviceInfo:lightcontrol];
    cell.delegate = self;
    return cell;
}

#pragma mark - LightswitchDemoTableViewCellDelegate methods
- (void)switchValueChangedInCell:(LightswitchDemoTableViewCell *)cell toValue:(BOOL)value;
{
    cell.switchControl.enabled = NO;
    [cell.spinner startAnimating];
  
   [[DLClient shared] updateDeviceWithDeviceID:cell.device.deviceGuid forAction:@"switch" withValue:value?@"on":@"off" completionHandler:^(BOOL success, NSNumber *transactionID) {
       // if there was no transaction id then the switch was already set to the value we requested, otherwise we mark the device as having a pending change on the "switch" label
       if (transactionID && (transactionID.integerValue != -1)) {
           cell.device.pendingChangeLabel = @"switch";
       }
       else {
           cell.switchControl.enabled = YES;
           [cell.spinner stopAnimating];
       }
   }];
}

#pragma mark - handle button taps
- (IBAction)allOnButtonTapped:(id)sender {
    for (DLDevice *lightcontrol in self.lightswitchDevices) {
        NSInteger tableRow = [self.lightswitchDevices indexOfObject:lightcontrol];
        LightswitchDemoTableViewCell *cell = (LightswitchDemoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:tableRow inSection:0]];
        if (cell) {
            [self switchValueChangedInCell:cell toValue:YES];
            cell.switchControl.on = YES;
       }
        else {
            NSLog(@"no cell!");
        }
    }
}

- (IBAction)allOffButtonTapped:(id)sender {
    for (DLDevice *lightcontrol in self.lightswitchDevices) {
        NSInteger tableRow = [self.lightswitchDevices indexOfObject:lightcontrol];
        LightswitchDemoTableViewCell *cell = (LightswitchDemoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:tableRow inSection:0]];
        if (cell) {
            [self switchValueChangedInCell:cell toValue:NO];
            cell.switchControl.on = NO;
        }
        else {
            NSLog(@"no cell!");
        }
   }
}

- (IBAction)toggleAllButtonTapped:(id)sender {
    for (DLDevice *lightcontrol in self.lightswitchDevices) {
        NSInteger tableRow = [self.lightswitchDevices indexOfObject:lightcontrol];
        LightswitchDemoTableViewCell *cell = (LightswitchDemoTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:tableRow inSection:0]];
        if (cell) {
            BOOL newvalue = !cell.switchControl.on;
            [self switchValueChangedInCell:cell toValue:newvalue];
            cell.switchControl.on = newvalue;
        }
        else {
            NSLog(@"no cell!");
        }
    }
}
@end
