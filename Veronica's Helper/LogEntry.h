//
//  LogEntry.m
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/3/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface LogEntry: NSObject

    @property NSString *date;
    @property NSString *bloodsugar;
    @property NSString *insulin;
    @property NSString *carbs;

-(NSString *)description;

@end