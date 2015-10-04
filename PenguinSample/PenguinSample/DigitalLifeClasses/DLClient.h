//
//  DLClient.h
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DLeServiceConnection.h"

@interface DLClient : NSObject

@property (readonly) NSArray *devices;
@property (readonly) NSMutableArray *eServiceMessages;
//@property (nonatomic,weak) id <eServiceDelegate>eServiceDelegate;

/**
 *  Singleton access method
 *
 *  @return shared DLClient object
 */
+ (instancetype)shared;

/**
 *  Authenticates user and stores retuned credentials
 *
 *  @param username   username as NSString (currently requires the mps number as username)
 *  @param password   password as NSString
 *  @param completion this block will be called upon completion, with success=YES if authentication is successful
 */
- (void)authenticateWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(BOOL success))completion;

/**
 *  Loads full device list
 *
 *  @param completion this block will be called upon completion, with success=YES and devices array if successful
 */
- (void)loadDevicesWithCompletion:(void (^)(BOOL success, NSArray *devices))completion;

/**
 *  Loads device logs for specified device
 *
 *  @param deviceID   deviceID for the device we are interested in
 *  @param completion this block will be called upon completion, with success=YES and device log array if successful
 */
- (void)loadDevicesLogsForDeviceID:(NSString *)deviceID withCompletion:(void (^)(BOOL success, NSArray *deviceLogItems))completion;

/**
 *  This api will update a particular attribute of a device (action) to a particular value.
 *
 *  @param deviceID                   deviceID for the device we are interested in
 *  @param action                     The label of the attribute you are updating
 *  @param value                      The value you want the attribute to be set to
 *  @param completion                 this block will be called upon completion. the transaction id is used to identify the eservice message that announces completion of the update
 */
- (void)updateDeviceWithDeviceID:(NSString *)deviceID forAction:(NSString *)action withValue:(NSString *)value completionHandler:(void (^)(BOOL success, NSNumber *transactionID))completion;

/**
 *  This api call will update the specified program with the specifed active/unactive status
 *
 *  @param programId                  id of program we are updaing
 *  @param active                     YES if setting program to active, NO if setting program to inactive
 *  @param completion                 this block will be called upon completion, passing the result of the update
 */
- (void)updateProgramActiveStatusForProgramID:(NSString *)programId withActiveStatus:(BOOL)active completionHandler:(void (^)(BOOL success))completion;

/**
 *  This api call tells the backend to run the specified program
 *
 *  @param programId  id of program we are updaing
 *  @param completion this block will be called upon completion, passing the result of the update
 */
- (void)runProgramWithID:(NSString *)programId completionHandler:(void (^)(BOOL success))completion;

/**
 *  Loads program list
 *
 *  @param completion this block will be called upon completion, with succeess=YES and program log array if successful
 */
- (void)loadProgramsWithCompletion:(void (^)(BOOL success, NSArray *programs))completion;

/**
 *  starts the eService connection
 *
 *  @param completion this block will be called upon completion, with success=YES if successful
 */
- (void)startEServiceWithCompletion:(void (^)(BOOL success))completion;


@property (readonly) DLeServiceConnection *eService;
@end


