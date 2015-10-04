//
//  DLeServiceConnection.m
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "DLeServiceConnection.h"
#import "URLHelpers.h"
#import "Constants.h"

@interface DLeServiceConnection () <NSURLConnectionDelegate,NSURLConnectionDataDelegate>
@property (nonatomic,copy) NSString *gatewayGuid;
@property (nonatomic,strong) NSURLConnection *eServiceConnection;
@property (nonatomic, copy) void (^connectCompletionBlock)(BOOL success);
@property (nonatomic,strong) NSMutableData *eServiceData;
@property (nonatomic,strong) NSMutableCharacterSet *charsToTrim;
@end

@implementation DLeServiceConnection

- (id)initWithGatewayGuid:(NSString *)gatewayGuid
{
    self = [super init];
    if (self) {
        _gatewayGuid = gatewayGuid;
        _eServiceData = [[NSMutableData alloc] init];
        _charsToTrim = [NSMutableCharacterSet whitespaceAndNewlineCharacterSet];
        [_charsToTrim addCharactersInString:@"*"];
    }
    return self;
}

- (void)connectWithCompletionHandler:(void(^)(BOOL succeess))completion
{
    self.connectCompletionBlock = completion;
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *url = [NSString stringWithFormat:@"%@?key=%@&uuid=%@&app2=%@",kBaseEserviceURL,self.gatewayGuid,uuid,[kDelimiter urlEncodedString]];

    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    [urlRequest setTimeoutInterval:24*60*60];
    [urlRequest setCachePolicy:NSURLRequestUseProtocolCachePolicy];
 
    self.eServiceConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
}

- (void)close
{
    [self.eServiceConnection cancel];
    self.eServiceConnection = nil;
}

#pragma mark - NSURLConnection delegate methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if (self.connectCompletionBlock) self.connectCompletionBlock(YES);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // add new data to our existing pool of data
    [self.eServiceData appendData:data];
    
    // now see if we have any complete messages (looping until we run out of messages in data pool)
    BOOL delimiterFound = YES;
    NSData *remainingData = self.eServiceData;
    NSData *pattern = [kDelimiter dataUsingEncoding:NSUTF8StringEncoding];
    
    while (delimiterFound && remainingData && ([remainingData length] > 0)) {
        NSRange range = [remainingData rangeOfData:pattern options:0 range:NSMakeRange(0, remainingData.length)];
        delimiterFound = (range.location != NSNotFound);
        if (delimiterFound) {
            // extract the message and trim both whitespace and extra *'s
            NSData *messageData = [remainingData subdataWithRange:NSMakeRange(0, range.location)];
            NSString *messageString = [[NSString alloc] initWithData:messageData encoding:NSUTF8StringEncoding];
            messageString = [messageString stringByTrimmingCharactersInSet:self.charsToTrim];
            
            // remove message bytes from pool
            NSRange remainingDataRange = NSMakeRange(range.location+[kDelimiter length], remainingData.length-(range.location+[kDelimiter length]));
            remainingData = [remainingData subdataWithRange:remainingDataRange];
            
            // post notification so anyone that cares can do something with the message
            NSError *jsonError;
            NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:[messageString dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonError];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"eServiceMessageReceived" object:nil userInfo:@{@"message":jsonDict,@"rawjson":messageString}];
        }
    }
    
    // save any leftover bytes for next time this method is called
    self.eServiceData = [remainingData mutableCopy];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    if (self.connectCompletionBlock) self.connectCompletionBlock(NO);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"eService connection has ended");
}
@end
