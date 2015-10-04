//
//  DeviceLogViewController.m
//  PenguinSample
//
//  Created on 11/4/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

/*********************************************************************************/
/* How to load device logs:                                                      */
/*                                                                               */
/*                                                                               */
/*                                                                               */
/*********************************************************************************/


#import "DeviceLogViewController.h"
#import "DLClient.h"

@interface DeviceLogViewController ()
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation DeviceLogViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    [[DLClient shared] loadDevicesLogsForDeviceID:self.device.deviceGuid withCompletion:^(BOOL success, NSArray *deviceLogItems) {
        if (success) {
            self.deviceLogItems = deviceLogItems;
            [self.tableView reloadData];
        }
        self.activityIndicator.hidden = YES;
        [self.activityIndicator stopAnimating];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Data Source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.deviceLogItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"deviceLogListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *deviceLogEntry = self.deviceLogItems[indexPath.row];

    cell.textLabel.text = [NSString stringWithFormat:@"%@",deviceLogEntry[@"name"]];
    NSNumber *timestamp = deviceLogEntry[@"timestamp"];
    NSDate *timestampDate = [NSDate dateWithTimeIntervalSince1970:timestamp.doubleValue/1000];
    
    cell.detailTextLabel.text = [timestampDate description];
    cell.detailTextLabel.hidden = NO;

    return cell;
}


@end
