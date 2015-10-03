//
//  ViewController.m
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/2/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
//

#import "ViewController.h"
#import "LogEntry.h"
#import "AppData.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *bloodsugarInput;
@property (weak, nonatomic) IBOutlet UITextField *carbInput;
@property (weak, nonatomic) IBOutlet UITextField *insulinInput;
@property (weak, nonatomic) IBOutlet UIButton *recordButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can berecreated.
}

   int count = 0; //will this restart the count everytime app is opened: YES 

- (IBAction)recordButton:(id)sender {
    
    NSString *bloodsugar = [self.bloodsugarInput text];
    NSString *carb = [self.carbInput text];
    NSString *insulin = [self.insulinInput text];
    NSMutableArray<NSString *> *logData = [[NSMutableArray alloc] init];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //uncomment to get the time only
    //[formatter setDateFormat:@"hh:mm a"];
    //[formatter setDateFormat:@"MMM dd, YYYY"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    
    //get the date today
    NSString *dateToday = [formatter stringFromDate:[NSDate date]];
    
    UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 20.0f)];
    [dateLabel setText:dateToday];
    
    printf("%d %d %.1lf \n", bloodsugar, carb, insulin);
    
    LogEntry *logEntry = [[LogEntry alloc] init];
    logEntry.date = dateToday;
    logEntry.bloodsugar = bloodsugar;
    logEntry.carbs = carb;
    logEntry.insulin = insulin;
    

    
    AppData *data = [AppData sharedInstance];
    [ data.logData  addObject: logEntry ];
}
    
    
@end
