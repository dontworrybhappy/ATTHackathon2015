//
//  DLeServiceConnection.h
//  PenguinSample
//
//  Created on 11/3/14.
//  Copyright (c) 2014 AT&T. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DLeServiceConnection : NSObject
- (instancetype)initWithGatewayGuid:(NSString *)gatewayGuid;
- (void)connectWithCompletionHandler:(void(^)(BOOL succeess))completion;
- (void)close;
@end
