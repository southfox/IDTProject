//
//  UdpManager.h
//  IDTProject
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Constant for the notification to know when a message is received
#define kUdpManagerDidReceiveMessageNotification @"kUdpManagerDidReceiveMessageNotification"

/// Failure completion Block
typedef void (^UdpFailureCompletion)(NSError *error);
/// Success completion Block
typedef void (^UdpSuccessCompletion)(NSInteger tag);

/// Udp Manager using GCDAsyncUdpSocket cocoapods library.
@interface UdpManager : NSObject

/// Singleton
+ (UdpManager *)sharedInstance;

/// Convenient export of 2 variables to know how many message sent/not sent from the client app.
@property (nonatomic, readonly) NSInteger numberOfMessagesSent;
@property (nonatomic, readonly) NSInteger numberOfMessagesNotSent;

/// Configure the manager as client, sends and confirm messages
- (void)configureManagerAsClient;

/// Configure the manager as server to listen in the port specified, receives and answers messages
- (void)configureManagerAsServerUsingPort:(NSInteger)port;

/// Only used by the client
/// Send a message to the defined host, port.
/// 2 blocks for failure and success are sent, to check parameters only, doesn't do any async work
- (void)sendMessage:(NSString *)message toHost:(NSString *)host port:(int)port failure:(UdpFailureCompletion)failure success:(UdpSuccessCompletion)success;

@end
