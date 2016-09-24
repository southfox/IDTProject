//
//  UdpManager.m
//  IDTProject
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import "UdpManager.h"

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


- (void)configureUdp {
    GCDAsyncUdpSocket *udpSocket = [[GCDAsyncUdpSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];

}


@end
