//
//  DeviceLogViewController.h
//  PenguinSample
//
//  Created on 11/4/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLDevice.h"

@interface DeviceLogViewController : UIViewController
@property (nonatomic,strong) NSArray *deviceLogItems;
@property (nonatomic,strong) DLDevice *device;
@end
