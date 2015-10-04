//
//  EServiceDetailViewController.m
//  PenguinSample
//
//  Created on 11/10/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "EServiceDetailViewController.h"

@interface EServiceDetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *eServiceDetailTextView;

@end

@implementation EServiceDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.eServiceDetailTextView.text = [self.eServiceMessageDict description];
}


@end
