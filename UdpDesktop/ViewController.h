//
//  ViewController.h
//  UdpDesktop
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ViewController : NSViewController
@property (unsafe_unretained) IBOutlet NSTextView *messageReceivedView;
@property (weak) IBOutlet NSTextField *portField;



@end

