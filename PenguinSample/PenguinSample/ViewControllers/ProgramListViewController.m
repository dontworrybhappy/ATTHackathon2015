//
//  ProgramListViewController.m
//  PenguinSample
//
//  Created on 11/5/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

/*********************************************************************************/
/* How to load the program list:                                                 */
/*                                                                               */
/*                                                                               */
/*                                                                               */
/* How to activate and deactivate programs:                                      */
/*                                                                               */
/*                                                                               */
/* How to run programs:                                                          */
/*                                                                               */
/*                                                                               */
/*********************************************************************************/

// TODO: add spinner that shows during loading

#import "ProgramListViewController.h"
#import "ProgramDetailViewController.h"
#import "DLClient.h"

@interface ProgramListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ProgramListViewController

// for debug
- (void)viewDidLoad
{
    [[DLClient shared] loadProgramsWithCompletion:^(BOOL success, NSArray *programs) {
        self.programList = programs;
        [self.tableView reloadData];
    }];
}

#pragma mark - TableView Data Source methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.programList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"programListCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = self.programList[indexPath.row][@"name"];
    
    return cell;
}

#pragma mark - TableView Delegate Methods
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *programDict = self.programList[indexPath.row];
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    ProgramDetailViewController *programDetailVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"ProgramDetailViewController"];
    programDetailVC.programDict = programDict;
    [self.navigationController pushViewController:programDetailVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

}
@end
