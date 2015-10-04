//
//  DLClient.m
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "DLClient.h"
#import "DLDevice.h"
#import "DLeServiceConnection.h"
#import "URLHelpers.h"
#import "JSONHelpers.h"
#import "Constants.h"

@interface DLClient ()
// info from user
@property (nonatomic,strong) NSString *userId;
@property (nonatomic,strong) NSString *password;

// info from backend
@property (nonatomic,strong) NSString *authToken;
@property (nonatomic,strong) NSString *requestToken;
@property (nonatomic,strong) NSString *gatewayGUID;
@property (nonatomic,strong) NSArray *devices;

// other
@property (nonatomic,strong) DLeServiceConnection *eService;
@property (nonatomic,strong) NSMutableArray *eServiceMessages;
@end


@implementation DLClient

+ (instancetype)shared
{
    static DLClient *sharedInstance = nil;
    static dispatch_once_t DDASLLoggerOnceToken;
    dispatch_once(&DDASLLoggerOnceToken, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        NSAssert(![kAppID isEqualToString:@"<ENTER APP_ID HERE>"],@"Please entter your app id in Constants.m before running the app");
        [[NSNotificationCenter defaultCenter] addObserverForName:@"eServiceMessageReceived" object:nil queue:nil usingBlock:^(NSNotification *note) {
            [self handleEServiceMessage:note.userInfo];
        }];
    }
    return self;
}

- (void)authenticateWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(BOOL success))completion
{
    NSAssert(completion != nil,@"Must have completion block");
    
    // save login info so we can re-login when authToken expires
    self.userId = username;
    self.password = password;
    
    // setup URL Request for authentication
    NSString *url = [NSString stringWithFormat:@"%@/authtokens",baseURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = @"POST";

    NSDictionary *postParams = @{@"userId":username,@"password":password,@"domain":@"DL",@"appKey":kAppID};
    NSString *postParamString = [postParams contentsAsURLQueryString];
    NSData *postParamData = [postParamString dataUsingEncoding:NSUTF8StringEncoding];
    [urlRequest setHTTPBody:postParamData];
    
    // start request for authentication
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        // handle response for authentication
        if (connectionError) {
            completion(NO);
            return;
        }

        // gather auth info from response
        NSDictionary *content = [JSONHelpers contentDictionaryFromJsonResponse:data];
        if (!content) {
            completion(NO);
            return;
        }
        self.authToken = [content objectForKey:@"authToken"];
        self.requestToken = [content objectForKey:@"requestToken"];
        self.gatewayGUID = [[[content objectForKey:@"gateways"] objectAtIndex:0] objectForKey:@"id"];

        completion(YES);
    }];
}


- (void)performHTTPRequestWithEndpoint:(NSString *)endpoint params:(NSDictionary *)params httpMethod:(NSString *)httpMethod completionHandler:(void (^)(BOOL success, id content))completionHandler
{
    NSAssert(completionHandler != nil,@"must have completion block");
    NSAssert(self.gatewayGUID,@"must be logged in before making api calls");
    
    // set up url with selected endpoint as well as the parameters passed in
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",baseURL,self.gatewayGUID,endpoint];
    if (params) {
        NSString *postParamString = [params contentsAsURLQueryString];
        url = [NSString stringWithFormat:@"%@?%@",url,postParamString];
    }
    
    // create url request and set authentication related http header values
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = httpMethod;
    [urlRequest addValue:self.authToken forHTTPHeaderField:@"authToken"];
    [urlRequest addValue:self.requestToken forHTTPHeaderField:@"requestToken"];
    [urlRequest addValue:kAppID forHTTPHeaderField:@"appKey"];
    
    // start the http request
    [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (connectionError) {
            completionHandler(NO,nil);
            return;
        }
        
        id content = [JSONHelpers contentFromJsonResponse:data];
        
        completionHandler(YES,content);
    }];
}

- (void)loadDevicesWithCompletion:(void (^)(BOOL success, NSArray *devices))completion
{
    [self performHTTPRequestWithEndpoint:@"devices" params:nil httpMethod:@"GET" completionHandler:^(BOOL success, id content) {
        if (!success || ![content isKindOfClass:[NSArray class]]) {
            completion(NO,nil);
        }
        
        // convert each json device entry to a DLDevice object
        NSArray *jsonDeviceList = content;
        NSMutableArray *deviceList = [[NSMutableArray alloc] init];
        for (NSDictionary *deviceDict in jsonDeviceList) {
            [deviceList addObject:[[DLDevice alloc] initWithDeviceDict:deviceDict]];
        }
        self.devices = [deviceList copy];
        if (completion) completion(YES,[deviceList copy]);
    }];
}

- (void)loadProgramsWithCompletion:(void (^)(BOOL success, NSArray *programs))completion
{
    [self performHTTPRequestWithEndpoint:@"programs" params:nil httpMethod:@"GET" completionHandler:^(BOOL success, id content) {
        if (!success || ![content isKindOfClass:[NSArray class]]) {
            completion(NO,nil);
        }

        if (completion) completion(YES,[content copy]);
    }];
}

- (void)loadDevicesLogsForDeviceID:(NSString *)deviceID withCompletion:(void (^)(BOOL success, NSArray *deviceLogItems))completion
{
    [self performHTTPRequestWithEndpoint:@"inbox" params:@{@"deviceGUID":deviceID} httpMethod:@"GET" completionHandler:^(BOOL success, id content) {
        if (!success || ![content isKindOfClass:[NSArray class]]) {
            completion(NO,nil);
        }
        
        if (completion) completion(YES,[content copy]);
    }];
}

- (void)updateDeviceWithDeviceID:(NSString *)deviceID forAction:(NSString *)action withValue:(NSString *)value completionHandler:(void (^)(BOOL success, NSNumber *transactionID))completion
{
    NSString *endpoint = [NSString stringWithFormat:@"devices/%@/%@/%@",deviceID,action,value];
    [self performHTTPRequestWithEndpoint:endpoint params:nil httpMethod:@"POST" completionHandler:^(BOOL success, id content) {
        if (content && [content isKindOfClass:[NSNumber class]]) {
            completion(success,content);
        }
        else {
            completion(success, nil);
        }
    }];
}

- (void)updateProgramActiveStatusForProgramID:(NSString *)programId withActiveStatus:(BOOL)active completionHandler:(void (^)(BOOL success))completion
{
    NSString *action = (active)?@"activate":@"deactivate";
    NSString *endpoint = [NSString stringWithFormat:@"programs/%@/%@",programId,action];
    [self performHTTPRequestWithEndpoint:endpoint params:nil httpMethod:@"POST" completionHandler:^(BOOL success, id content) {
        completion(success);
    }];
}

- (void)runProgramWithID:(NSString *)programId completionHandler:(void (^)(BOOL success))completion
{
    NSString *endpoint = [NSString stringWithFormat:@"programs/%@/run",programId];
    [self performHTTPRequestWithEndpoint:endpoint params:nil httpMethod:@"POST" completionHandler:^(BOOL success, id content) {
        completion(success);
    }];
}

- (void)startEServiceWithCompletion:(void (^)(BOOL success))completion
{
    // make sure we already logged in
    NSAssert(self.gatewayGUID, @"must be logged in before staring eService");

    // if we already have an eService, shut it down before we start a new one
    if (self.eService) {
        [self.eService close];
        self.eService = nil;
    }
    
    // create and connect new eService
    self.eService = [[DLeServiceConnection alloc] initWithGatewayGuid:self.gatewayGUID];
    [self.eService connectWithCompletionHandler:^(BOOL success) {
        completion(success);
    }];
}

- (DLDevice *)deviceWithID:(NSString *)deviceID
{
    __block DLDevice *foundDevice = nil;
    [self.devices enumerateObjectsUsingBlock:^(DLDevice *device, NSUInteger idx, BOOL *stop) {
        if ([device.deviceGuid isEqualToString:deviceID]) {
            foundDevice = device;
            *stop = YES;
        }
    }];
    return foundDevice;
}

#pragma mark - eService delegate methods
- (void)handleEServiceMessage:(NSDictionary *)message
{
    if (!self.eServiceMessages) {
        self.eServiceMessages = [[NSMutableArray alloc] init];
    }
    
    // add to our list of messages (we're only keeping these to be able to display in the eservice log, otherwise they can be discarded after they are used)
    [self.eServiceMessages addObject:message];
    
    NSDictionary *jsonMessage = message[@"message"];
    
    // if the messsage is of type "device", find and update the device record
    if ([jsonMessage[@"type"] isEqualToString:@"device"]) {
        DLDevice *device = [self deviceWithID:jsonMessage[@"dev"]];
        if (device) {
            [device updateWithMessage:jsonMessage];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"DeviceUpdated" object:nil userInfo:@{@"device":device}];
        }
        else {
            NSLog(@"got a device message but didn't find the device... message = %@",message);
        }
    }
}
@end

