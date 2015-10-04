//
//  URLHelpers.h
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (NSFoundation_DLAdditions)
/**
 *  Returns a url encoded copy of the input string
 *
 *  @return url encoded copy of the string this is called on
 */
-(NSString *)urlEncodedString;
@end

@interface NSDictionary (NSFoundation_DLAdditions)
/**
 *  Returns a url query string with the contents of the dictionary this is called on
 *
 *  @return NSString in url query format (e.g. "param1=value1&param2=value2")
 */
-(NSString *)contentsAsURLQueryString;
@end