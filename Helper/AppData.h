//
//  AppData.h
//  ObjCTest
//
//  Created by Brandon Rich2 on 10/3/15.
//  Copyright © 2015 Infinite Donuts. All rights reserved.
//
#import "LogEntry.h"

@interface AppData : NSObject

    @property NSMutableArray<LogEntry *> *logData;

    + (AppData *)sharedInstance;

@end

