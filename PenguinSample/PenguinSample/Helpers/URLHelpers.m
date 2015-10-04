//
//  URLHelpers.m
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "URLHelpers.h"

#pragma mark - helpers


@implementation NSString (NSFoundation_DLAdditions)


-(NSString *)urlEncodedString {
    NSMutableString *encoded = [[self stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    [encoded replaceOccurrencesOfString:@"&" withString:@"%26" options:NSCaseInsensitiveSearch range:NSMakeRange(0, encoded.length)];
    [encoded replaceOccurrencesOfString:@"+" withString:@"%2B" options:NSCaseInsensitiveSearch range:NSMakeRange(0, encoded.length)];
    return encoded;
}

@end


@implementation NSDictionary (NSFoundation_DLAdditions)

-(NSString *)contentsAsURLQueryString {
    if ([self count] == 0) {
        return nil;
    }
    
    NSMutableString *string = [NSMutableString string];
    NSArray *keys = [self allKeys];
    for (NSString *key in keys) {
        id object = [self objectForKey:key];
        if ([object isKindOfClass:[NSString class]]) {
            object = object;
        }
        else if ([object respondsToSelector:@selector(stringValue)]) {
            object = [object stringValue];
        }
        else {
            [[NSException exceptionWithName:NSGenericException reason:@"Bad request object" userInfo:nil] raise];
        }
        [string appendFormat:@"%@=%@", key, [key isEqualToString:@"appID"]?[object description]:[[object description] urlEncodedString]];
        if ([keys lastObject] != key) {
            [string appendString:@"&"];
        }
    }
    return string;
}


@end
