//
//  eServiceLogViewController.m
//  PenguinSample
//
//  Created on 11/5/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

// TODO: add detail view
// TODO: improve cells in this list to show more info in better format

#import "eServiceLogViewController.h"
#import "EServiceDetailViewController.h"
#import "DLClient.h"

@interface eServiceLogViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation eServiceLogViewController

#pragma mark - TableView Data Source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[DLClient shared] eServiceMessages] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"eServiceLogListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    NSDictionary *eServiceEntry = [[[DLClient shared] eServiceMessages] objectAtIndex:[[[DLClient shared] eServiceMessages] count]-indexPath.row-1][@"message"];
    
    cell.textLabel.text = [NSString stringWithFormat:@"label=%@ dev=%@ value=%@",eServiceEntry[@"label"],eServiceEntry[@"dev"],eServiceEntry[@"value"]];

    return cell;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *eServiceMessageDict = [[[DLClient shared] eServiceMessages] objectAtIndex:[[[DLClient shared] eServiceMessages] count]-indexPath.row-1][@"message"];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    EServiceDetailViewController *eServiceDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"EServiceDetailViewController"];
    eServiceDetailVC.eServiceMessageDict = eServiceMessageDict;
    [self.navigationController pushViewController:eServiceDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
@end
