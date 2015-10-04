//
//  DLDevice.m
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import "DLDevice.h"

@implementation DLDevice

- (instancetype)initWithDeviceDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        if (dict) {
            // convert the attributes array into a dictionary with label values as keys
            NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
            NSArray *rawAttributeList = dict[@"attributes"];
            [rawAttributeList enumerateObjectsUsingBlock:^(NSDictionary *attributeDict, NSUInteger idx, BOOL *stop) {
                [attributes setObject:attributeDict forKey:attributeDict[@"label"]];
            }];
            
            // gather the info we need from the device
            _deviceGuid = dict[@"deviceGuid"];
            _deviceType = dict[@"deviceType"];
            _deviceName = attributes[@"name"][@"value"];
            _attributes = attributes;
        }
    }
    return self;
}

- (void)updateWithMessage:(NSDictionary *)message
{
    [self.attributes enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {

        if ([key isEqualToString:message[@"label"]]) {
            NSMutableDictionary *attributeDict = [obj mutableCopy];
            attributeDict[@"value"] = message[@"value"];
            self.attributes[key] = attributeDict;
        }
    }];
    
    // also check to see if these are the pending changes we are expecting
    if ([message[@"label"] isEqualToString:self.pendingChangeLabel]) {
        self.pendingChangeLabel = nil;
    }
}

@end
