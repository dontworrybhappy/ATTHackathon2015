//
//  ProgramDetailViewController.m
//  PenguinSample
//
//  Created on 11/10/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "ProgramDetailViewController.h"
#import "DLClient.h"

@interface ProgramDetailViewController ()
@property (weak, nonatomic) IBOutlet UILabel *programName;
@property (weak, nonatomic) IBOutlet UILabel *programType;
@property (weak, nonatomic) IBOutlet UILabel *programID;
@property (strong, nonatomic) IBOutlet UISwitch *activeSwitch;
- (IBAction)activeSwitchValueChanged:(id)sender;
- (IBAction)runProgramButtonTapped:(id)sender;
@end

@implementation ProgramDetailViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.programName.text = self.programDict[@"name"];
    self.programType.text = self.programDict[@"type"];
    self.programID.text = [self.programDict[@"id"] stringValue];
    int active = [[self.programDict objectForKey:@"active"] integerValue];
    self.activeSwitch.on = (active != 0);
}

- (IBAction)activeSwitchValueChanged:(id)sender {
    BOOL newValue = self.activeSwitch.on;
    
    [[DLClient shared] updateProgramActiveStatusForProgramID:[self.programDict[@"id"] stringValue] withActiveStatus:newValue completionHandler:^(BOOL success) {
        NSLog(@"updateProgramActiveStatusForProgramID:%@ completed with result = %@",self.programID,(success)?@"success":@"failure");
    }];
    
    
}

- (IBAction)runProgramButtonTapped:(id)sender {
    // TODO: implement program run
    [[DLClient shared] runProgramWithID:[self.programDict[@"id"] stringValue] completionHandler:^(BOOL success) {
        NSLog(@"command to run program has been sent");
    }];
}
@end
