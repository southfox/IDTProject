//
//  ViewController.m
//  UdpDesktop
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import "ViewController.h"
#import <EXTScope.h>
#import "UdpManager.h"

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    [self addObserver];
	@onExit {
        [self removeObserver];
	};
    [self.portField setStringValue:@"5555"];
    [[UdpManager sharedInstance] configureManagerAsServerUsingPort:[self.portField intValue]];
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark -
#pragma mark update UI

- (void)updateMessageReceived:(NSString *)messageText
{
    NSString *paragraph = [NSString stringWithFormat:@"%@\n", messageText];
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:1];
    [attributes setObject:[NSColor purpleColor] forKey:NSForegroundColorAttributeName];
    
    NSAttributedString *as = [[NSAttributedString alloc] initWithString:paragraph attributes:attributes];
    
    [[self.messageReceivedView textStorage] appendAttributedString:as];
    [self scrollToBottom];
}

- (void)scrollToBottom
{
    NSScrollView *scrollView = [self.messageReceivedView enclosingScrollView];
    NSPoint newScrollOrigin;
    
    if ([[scrollView documentView] isFlipped]) {
        newScrollOrigin = NSMakePoint(0.0F, NSMaxY([[scrollView documentView] frame]));
    } else {
        newScrollOrigin = NSMakePoint(0.0F, 0.0F);
    }
    
    [[scrollView documentView] scrollPoint:newScrollOrigin];
}

- (IBAction)restartAction:(id)sender {
    int port = [self.portField intValue];

    [[UdpManager sharedInstance] configureManagerAsServerUsingPort:port];
}

#pragma mark -
#pragma mark Notifications 

- (void)removeObserver {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)addObserver {
    @weakify(self)
    [[NSNotificationCenter defaultCenter] addObserverForName:kUdpManagerDidReceiveMessageNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        @strongify(self)
        
        NSString *messageText = (NSString *)note.object;
        [self updateMessageReceived:messageText];
    }];
}


@end
