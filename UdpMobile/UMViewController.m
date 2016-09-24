//
//  UMViewController.m
//  UdpMobile
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import "UMViewController.h"
#import <SCLAlertView.h>
#import <EXTScope.h>
#import "UdpManager.h"

@interface UMViewController ()
@property (weak, nonatomic) IBOutlet UITextField *hostField;
@property (weak, nonatomic) IBOutlet UITextField *portField;
@property (weak, nonatomic) IBOutlet UITextView *messageField;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@end

@implementation UMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.hostField.text = @"192.168.2.5";
    self.portField.text = @"5555";
    self.messageField.text = @"Hey 😀!";
    
    [self addObserver];
	@onExit {
        [self removeObserver];
	};
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoAction:(id)sender {
    UdpManager * mgr = [UdpManager sharedInstance];
     NSString *message = [NSString stringWithFormat:@"Messages Sent: %ld - Messages Not Sent: %ld",
                          mgr.numberOfMessagesSent,
                          mgr.numberOfMessagesNotSent];
    [self showInfoWithTitle:@"Info" message:message];
}


- (IBAction)sendAction {
    
    @weakify(self)
    for (id field in @[self.hostField, self.portField, self.messageField]) {
        [field endEditing:YES];
    }
    
    if (self.hostField.text.length == 0) {
        SCLActionBlock actionBlock = ^() {
            @strongify(self);
            [self.hostField becomeFirstResponder];
        };
        [self showWarningWithBlock:actionBlock title:@"Invalid Host" message:@"Please enter a valid host"];
        return;
    }
    
    int port = (int)[self.portField.text integerValue];
    if (port == 0) {
        SCLActionBlock actionBlock = ^() {
            @strongify(self);
            [self.portField becomeFirstResponder];
        };
        [self showWarningWithBlock:actionBlock title:@"Invalid Port" message:@"Please enter a valid port number"];
        return;
    }
    
    if (self.messageField.text.length == 0) {
        SCLActionBlock actionBlock = ^() {
            @strongify(self);
            [self.messageField becomeFirstResponder];
        };
        [self showWarningWithBlock:actionBlock title:@"Empty message" message:@"Please enter a message"];
        return;
    }
    
    [[UdpManager sharedInstance] sendMessage:self.messageField.text toHost:self.hostField.text port:port
     failure:^(NSError *error) {
        @strongify(self);
        [self showWarningWithBlock:nil title:@"Udp Manager error" message:error.userInfo[NSLocalizedDescriptionKey]];
     } success:^(NSInteger tag) {
         NSLog(@"Sending message with tag #%ld", (long)tag);
    }];
}


- (void)showAlertWithBlock:(SCLActionBlock)actionBlock title:(NSString *)title message:(NSString *)message isWarning:(BOOL)isWarning {
    SCLAlertView *alert = [[SCLAlertView alloc] initWithNewWindow];
    alert.shouldDismissOnTapOutside = YES;
    if (isWarning) {
        [alert showWarning:title subTitle:message closeButtonTitle:nil duration:0.0f];
    }
    else {
        [alert showInfo:title subTitle:message closeButtonTitle:nil duration:0.0f];
    }
    if (actionBlock) {
        [alert addButton:@"Ok" actionBlock:actionBlock];
    }
}


- (void)showWarningWithBlock:(SCLActionBlock)actionBlock title:(NSString *)title message:(NSString *)message {
    [self showAlertWithBlock:actionBlock title:title message:message isWarning:YES];
}

- (void)showInfoWithTitle:(NSString *)title message:(NSString *)message {
    [self showAlertWithBlock:nil title:title message:message isWarning:NO];
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
        [self showInfoWithTitle:@"Success" message:messageText];
    }];
}


@end
