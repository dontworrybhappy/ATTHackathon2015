//
//  ViewController.m
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

/*********************************************************************************/
/* How to authenticate a user:                                                   */
/*                                                                               */
/*                                                                               */
/*                                                                               */
/*********************************************************************************/

#import "LoginViewController.h"
#import "DLClient.h"
#import "DeviceListViewController.h"
#import "DLeServiceConnection.h"
#import "Constants.h"
#import "MainViewController.h"

// TODO: add logout

@interface ViewController ()
- (IBAction)nextPageButtonPressed:(id)sender;
- (IBAction)loginButtonTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *loginResultBox;
@property (weak, nonatomic) IBOutlet UIButton *nextPageButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet UILabel *authenicationStatusLabel;
@property (weak, nonatomic) IBOutlet UIButton *loadDevicesButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *authSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *eServiceSpinner;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loadingDevicesSpinner;
@property (weak, nonatomic) IBOutlet UILabel *authCheckmark;
@property (weak, nonatomic) IBOutlet UILabel *eServiceCheckmark;
@property (weak, nonatomic) IBOutlet UILabel *loadingDevicesCheckmark;
@property (weak, nonatomic) IBOutlet UILabel *greenCheckmarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *redXLabel;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.usernameTextfield.text = kSampleUsername;
    self.passwordTextfield.text = kSamplePassword;
    self.authSpinner.hidden = YES;
    self.eServiceSpinner.hidden = YES;
    self.loadingDevicesSpinner.hidden = YES;
}

- (void)showSuccessResultForLabel:(UILabel *)label success:(BOOL)success
{
    label.hidden = NO;
    label.text = (success)?self.greenCheckmarkLabel.text:self.redXLabel.text;
}

- (void)startSpinner:(UIActivityIndicatorView *)spinner
{
    spinner.hidden = NO;
    [spinner startAnimating];
}

- (void)endSpinner:(UIActivityIndicatorView *)spinner
{
    spinner.hidden = YES;
    [spinner stopAnimating];
}

- (IBAction)nextPageButtonPressed:(id)sender {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        MainViewController *mainVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        [self.navigationController pushViewController:mainVC animated:YES];
}

- (IBAction)loginButtonTapped:(id)sender {
    DLClient *client = [DLClient shared];
    [self startSpinner:self.authSpinner];
    self.loginResultBox.hidden = NO;
    [client authenticateWithUsername:self.usernameTextfield.text password:self.passwordTextfield.text completion:^(BOOL success){
        [self endSpinner:self.authSpinner];
        [self showSuccessResultForLabel:self.authCheckmark success:success];

        if (success) [self startEService];
    }];
}

- (void)loadDevices {
    [self startSpinner:self.loadingDevicesSpinner];
    [[DLClient shared] loadDevicesWithCompletion:^(BOOL success, NSArray *devices) {
        [self endSpinner:self.loadingDevicesSpinner];
        [self showSuccessResultForLabel:self.loadingDevicesCheckmark success:success];
        if (success) self.nextPageButton.hidden = NO;
    }];
}

- (void)startEService {
    [self startSpinner:self.eServiceSpinner];
    [[DLClient shared] startEServiceWithCompletion:^(BOOL success) {
        [self endSpinner:self.eServiceSpinner];
        [self showSuccessResultForLabel:self.eServiceCheckmark success:success];
        if (success) [self loadDevices];
    }];
}

@end
