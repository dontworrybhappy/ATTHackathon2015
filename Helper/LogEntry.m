//
//  LogEntry.m
//  Veronica's Helper
//
//  Created by Patricia "Happy" Hale on 10/3/15.
//  Copyright © 2015 Patricia "Happy" Hale. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LogEntry.h"

@implementation LogEntry

- (NSString *) description {
    return [NSString stringWithFormat: @"Name: %@ %@ %@ %@", self.date, self.bloodsugar, self.carbs, self.insulin];
}
@end