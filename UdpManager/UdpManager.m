//
//  UdpManager.m
//  IDTProject
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import "UdpManager.h"

#import <GCDAsyncUdpSocket.h>

#define kUdpManagerDidReceiveMessageNotification @"kUdpManagerDidReceiveMessageNotification"

@interface UdpManager() <GCDAsyncUdpSocketDelegate>
@property (nonatomic, strong) GCDAsyncUdpSocket *udpSocket;
@property (nonatomic) NSInteger tag;
@property (nonatomic) NSInteger numberOfUnknownMessagesReceived;
@property (nonatomic) NSInteger numberOfKnownMessagesReceived;
@property (nonatomic) NSInteger numberOfMessagesSent;
@property (nonatomic) NSInteger numberOfMessagesNotSent;
@property (nonatomic) BOOL isConfigured;
@property (nonatomic) BOOL isConfiguredAsServer;
@end

@implementation UdpManager

+ (UdpManager *)sharedInstance
{
    static UdpManager *_sharedInstance = nil;
    
    @synchronized (self)
    {
        if (_sharedInstance == nil)
        {
            _sharedInstance = [[self alloc] init];
        }
    }
    
    return _sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (void)configureManagerAsServer {
    self.isConfiguredAsServer = YES;
    [self configureUdpWithPort:5555];
}

- (void)configureManagerAsClient {
    self.isConfiguredAsServer = NO;
    [self configureUdpWithPort:0];
}


- (void)configureUdpWithPort:(NSInteger)port {

    NSError *error = nil;
    if (![self.udpSocket bindToPort:port error:&error])
    {
        NSLog(@"Cannot configure udp socket error = %@", error.description);
        return;
    }
    
    if (![self.udpSocket beginReceiving:&error])
    {
        NSLog(@"Cannot configure bind receiving socket error = %@", error.description);
        return;
    }
    self.isConfigured = YES;

}


- (GCDAsyncUdpSocket *)udpSocket {
    if (_udpSocket == nil) {
        _udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    
    return _udpSocket;
}

- (void)sendMessage:(NSString *)message toHost:(NSString *)host port:(int)port {
    
    NSAssert(!self.isConfiguredAsServer, @"This is a server, it cannot use this method");
    
    NSAssert(self.isConfigured, @"Client socket is not configured yet");
    
    if (!self.isConfigured) {
        return;
    }
    
    if (port <= 0 || port > 65535) {
        NSAssert(NO, @"Illegal port");
        return;
    }

    if ([message length] == 0) {
        NSAssert(NO, @"empty message");
        return;
    }
    
    NSData *data = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.udpSocket sendData:data toHost:host port:port withTimeout:-1 tag:self.tag];
    
    NSLog(@"Sending Message = %@, to Host = %@, port = %d, tag = %ld", message, host, port, self.tag);
    
    self.tag++;
    
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    self.numberOfMessagesSent++;
    NSLog(@"number of messages Sent = %ld, tag = %ld", (long)self.numberOfMessagesSent, tag);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    self.numberOfMessagesNotSent++;
    NSLog(@"number of messages NOT Sent = %ld, tag = %ld, error = %@", (long)self.numberOfMessagesNotSent, tag, error.description);
}

- (void)udpSocket:(GCDAsyncUdpSocket *)sock didReceiveData:(NSData *)data
      fromAddress:(NSData *)address
withFilterContext:(id)filterContext
{
    NSString *msg = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    if (msg)
    {
        NSLog(@"received msg = [%@](%ld)", msg, [msg length]);
        [[NSNotificationCenter defaultCenter] postNotificationName:kUdpManagerDidReceiveMessageNotification object:msg];
        self.numberOfKnownMessagesReceived++;
    }
    else
    {
        NSString *host = nil;
        uint16_t port = 0;
        [GCDAsyncUdpSocket getHost:&host port:&port fromAddress:address];
        
        NSLog(@"unknown msg from [%@](%hu)", host, port);
        self.numberOfUnknownMessagesReceived++;
    }
    
    if (self.isConfiguredAsServer) {
        [self.udpSocket sendData:data toAddress:address withTimeout:-1 tag:0];
        NSLog(@"Now send the same data recievied");
    }
}



@end
