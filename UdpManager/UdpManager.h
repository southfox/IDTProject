//
//  UdpManager.h
//  IDTProject
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kUdpManagerDidReceiveMessageNotification @"kUdpManagerDidReceiveMessageNotification"

typedef void (^UdpFailureCompletion)(NSError *error);

typedef void (^UdpSuccessCompletion)(NSInteger tag);

@interface UdpManager : NSObject

+ (UdpManager *)sharedInstance;

@property (nonatomic, readonly) NSInteger numberOfMessagesSent;
@property (nonatomic, readonly) NSInteger numberOfMessagesNotSent;

- (void)configureManagerAsClient;
- (void)configureManagerAsServer;

- (void)sendMessage:(NSString *)message toHost:(NSString *)host port:(int)port failure:(UdpFailureCompletion)failure success:(UdpSuccessCompletion)success;

@end
