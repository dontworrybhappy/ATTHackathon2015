//
//  LogViewController.m
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/3/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
//

#import "LogViewController.h"
#import "LogTableCell.h"
#import "AppData.h"
#import "LogEntry.h"


@interface LogViewController () <UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property AppData *data;


@end

@implementation LogViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[LogTableCell class] forCellReuseIdentifier:@"Cell"];
    self.tableView.separatorColor = [UIColor lightGrayColor];
    self.tableView.dataSource = self;
    [self.tableView reloadData];
        //NSLog( [NSString stringWithFormat:@"count of logentries %D", [self.data.logData count]], @""   );
 
}

- (void) viewWillAppear:(BOOL)animated {
    self.data = [AppData sharedInstance];
    [self.tableView reloadData];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data.logData count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LogEntry *currentEntry = [self.data.logData objectAtIndex:indexPath.row];
    LogTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.date.text = [NSString stringWithFormat:@"Date %@", currentEntry.date];
    //cell.bloodSugar.text = [NSString stringWithFormat:@"Blood Sugar %ld", (long)indexPath.row];
    //cell.carbs.text = [NSString stringWithFormat:@"End %ld", (long)indexPath.row];
    //cell.insulin.text = [NSString stringWithFormat:@"End %ld", (long)indexPath.row];
    return cell;
}

@end
