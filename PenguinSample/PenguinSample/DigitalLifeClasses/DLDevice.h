//
//  DLDevice.h
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DLDevice : NSObject
@property (nonatomic,strong) NSString *deviceType;
@property (nonatomic,strong) NSString *deviceGuid;
@property (nonatomic,strong) NSString *deviceName;
@property (nonatomic,strong) NSMutableDictionary *attributes;

// this lets us keep track of pending changes for this device
@property (nonatomic,strong) NSString *pendingChangeLabel; // will be nil if no pending change


/**
 *  Designated initializer for DLDevice, takes a device dict as returned from the backend and stores the values we care about
 *
 *  @param dict NSDictionary in format returned by backend
 *
 *  @return an instance of DLDevice with values populated from the dict
 */
- (instancetype)initWithDeviceDict:(NSDictionary *)dict;

/**
 *  Updates the value specified by the label
 *
 *  @param message this is the dictionary received from eService
 */
- (void)updateWithMessage:(NSDictionary *)message;
@end
