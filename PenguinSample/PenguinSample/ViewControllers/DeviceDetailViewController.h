//
//  DeviceDetailViewController.h
//  PenguinSample
//
//  Created on 11/4/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DLDevice;

@interface DeviceDetailViewController : UIViewController
@property (nonatomic,strong) DLDevice *device;
@end
