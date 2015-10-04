//
//  JSONHelpers.h
//  PenguinSample
//
//  Created on 11/5/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONHelpers : NSObject

// these methods extract the content element from the json response. If content element is the expected type it is returned, otherwise nil is returned

/**
 *  Extracts the "content" portion of a raw JSON response from an api call
 *
 *  @param jsonData NSData object typically received from api call
 *
 *  @return content section if it exists, otherwise nil
 */
+ (id)contentFromJsonResponse:(NSData *)jsonData;

/**
 *  Extracts the "content" portion of a raw JSON response as an NSArray
 *
 *  @param jsonData NSData object typically received from api call
 
 *  @return content section if it exists and is an NSArray, otherwise nil
 */
+ (NSArray *)contentArrayFromJsonResponse:(NSData *)jsonData;


/**
 *  Extracts the "content" portion of a raw JSON response as an NSDictionary
 *
 *  @param jsonData NSData object typically received from api call
 
 *  @return content section if it exists and is an NSDictionary, otherwise nil
 */
+ (NSDictionary *)contentDictionaryFromJsonResponse:(NSData *)jsonData;


@end
