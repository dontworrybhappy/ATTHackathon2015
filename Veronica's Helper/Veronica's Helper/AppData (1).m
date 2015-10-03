//
//  AppData.m
//  ObjCTest
//
//  Created by Brandon Rich2 on 10/3/15.
//  Copyright © 2015 Infinite Donuts. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"

@implementation AppData

+ (AppData *)sharedInstance {
    static dispatch_once_t onceToken;
    static AppData *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[AppData alloc] init];
    });
    return instance;
}


- (id)init {
    self = [super init];
    if (self) {
        self.logData = [[NSMutableArray<LogEntry*> alloc]init];
    }
    return self;
}

@end

