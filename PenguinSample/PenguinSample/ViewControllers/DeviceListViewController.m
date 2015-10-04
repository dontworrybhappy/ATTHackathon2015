//
//  DeviceListViewController.m
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

/*********************************************************************************/
/* How to turn load the device list:                                             */
/*                                                                               */
/*                                                                               */
/*                                                                               */
/*********************************************************************************/

#import "DeviceListViewController.h"
#import "DeviceDetailViewController.h"
#import "DLClient.h"
#import "DLDevice.h"
#import "DeviceTableViewCell.h"

@interface DeviceListViewController () <UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *devices;
@end

@implementation DeviceListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.devices = [[DLClient shared] devices];
    
    if (!self.devices) {
        [[DLClient shared] loadDevicesWithCompletion:^(BOOL success, NSArray *devices) {
            if (!success) {
                NSLog(@"failed to load");
                return;
            }
            
            self.devices = devices;
            [self.tableView reloadData];
        }];
    }
}


#pragma mark - TableView Data Source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.devices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"DeviceTableViewCell";
    DeviceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    DLDevice *device = self.devices[indexPath.row];
    cell.nameLabel.text = device.deviceName;
    cell.typeLabel.text = device.deviceType;
    cell.guidLabel.text = device.deviceGuid;
    return cell;
}

#pragma mark - TableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DLDevice *device = [self.devices objectAtIndex:indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    DeviceDetailViewController *deviceDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"DeviceDetailViewController"];
    deviceDetailVC.device = device;
    [self.navigationController pushViewController:deviceDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}


@end
