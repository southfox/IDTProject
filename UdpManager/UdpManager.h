//
//  UdpManager.h
//  IDTProject
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UdpManager : NSObject

+ (UdpManager *)sharedInstance;

- (void)configureManagerAsClient;
- (void)configureManagerAsServer;

- (void)sendMessage:(NSString *)message toHost:(NSString *)host port:(int)port;

@end
