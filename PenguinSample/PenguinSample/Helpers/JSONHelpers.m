//
//  JSONHelpers.m
//  PenguinSample
//
//  Created on 11/5/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "JSONHelpers.h"

@implementation JSONHelpers


+ (id)contentFromJsonResponse:(NSData *)jsonData
{
    // convert JSON response to native objects
    NSError *error;
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
    if (error || !responseJSON) {
        return nil;
    }
    
    return responseJSON[@"content"];
}


+ (NSArray *)contentArrayFromJsonResponse:(NSData *)jsonData
{
    id content = [self contentFromJsonResponse:jsonData];
    return (content && [content isKindOfClass:[NSArray class]])?content:nil;
}


+ (NSDictionary *)contentDictionaryFromJsonResponse:(NSData *)jsonData
{
    id content = [self contentFromJsonResponse:jsonData];
    return (content && [content isKindOfClass:[NSDictionary class]])?content:nil;
}

@end
