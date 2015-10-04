//
//  ViewController.m
//  DiabetesAppHackathonATT
//
//  Created by Emily Koh on 10/2/15.
//  Copyright © 2015 Emily Koh. All rights reserved.
//

#import "ViewController.h"
#import "JSONHelpers.h"
#import "URLHelpers.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *SOS;
- (IBAction)SOS:(id)sender;
@property NSString *userId;
@property NSString *password;
@property NSString *baseURL;
@property NSString *authToken;
@property NSString *requestToken;
@property NSString *gatewayGUID;
@property NSString *devices;
//@property NSString *value;
//@property NSString *attributes;
//@property NSString *label;


@end

@implementation ViewController
NSString *const baseURL = @"http://systest.digitallife.att.com/penguin/api/";
NSString *const kAppID = @"NE_92666F094F1786C1_1";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // save login info so we can re-login when authToken expires
    self.userId = @"553474449";
    self.password = @"NO-PASSWD";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)SOS:(id)sender {
    [self authenticateWithUsername:self.userId password:self.password completion:^(BOOL success){
        printf("Log-in successful");
 
        [self performHTTPRequestWithEndpoint:@"devices" params:nil httpMethod:@"GET" completionHandler:^(BOOL success, id content) {
            
            
            // convert each json device entry to a DLDevice object
            NSArray *jsonDeviceList = content;
            NSMutableArray *deviceList = [[NSMutableArray alloc] init];
            for (NSDictionary *deviceDict in jsonDeviceList){
                if ([deviceDict[@"deviceType"] isEqual: @"door-lock"] ) {
                    if ([deviceDict[@"attributes"][3][@"value"]  isEqual: @"lock"]) {
                        NSString *endpoint = [NSString stringWithFormat:@"devices/DL00000004/lock/unlock"];
                    [self performHTTPRequestWithEndpoint:endpoint params:nil httpMethod:@"POST" completionHandler:^(BOOL success, id content) {
                        NSLog(@"success - door unlocked");
                    }];
                    }
                }
                if ([deviceDict[@"deviceType"] isEqual: @"digital-life-system"] ) {
                    NSLog(@"found");
                    if ([deviceDict[@"attributes"][1][@"value"]  isEqual: @"null"]) {
                        NSString *endpoint = [NSString stringWithFormat:@"devices/AM00000004/command/MedicalLocal!User=553474449[Desktop Web:1443924496237]!"];
                        [self performHTTPRequestWithEndpoint:endpoint params:nil httpMethod:@"POST" completionHandler:^(BOOL success, id content) {
                            NSLog(@"success - alarm beeps");
                        }];
                    }
                }
            }
            
            }];
    }];
    
}


- (void)authenticateWithUsername:(NSString*)username password:(NSString*)password completion:(void (^)(BOOL success))completion
{
    NSAssert(completion != nil,@"Must have completion block");
    
    
    
    // setup URL Request for authentication
    NSString *url = [NSString stringWithFormat:@"%@/authtokens",baseURL];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    urlRequest.HTTPMethod = @"POST";
    
    NSDictionary *postParams = @{
                                 @"userId":@"553474449",
                                 @"password":@"NO-PASSWD",
                                 @"domain":@"DL",
                                 @"appKey":kAppID
                                 };
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

     @end