IDT test
========

# Objective
Implementation in Objective-C. The code is documented answering "why" (more important than "what"). 

# Porpuse
3 objectives: reverse method, autorelease and client-server UDP implementation.

## Reverse method
1. Function which takes a string as argument and returns the string reversed. For example, "abcdef" becomes "fedcba". Not using the reverse method. It work with emojis.

### Answer

```objective-c
/// Reverse string method using Objective-C
/// Suports unicode and emoji characters
/// @param receives an string
- (NSString *)reverseStringObjC:(NSString *)string {
    unsigned long lenOfString = string.length;
    if (!string || lenOfString == 1) {
        return string;
    }
    NSMutableString *reversed = [[NSMutableString alloc] init];
    for (NSRange range = NSMakeRange(lenOfString-1, 1); (int)range.location >= 0; range.location--) {
        range = [string rangeOfComposedCharacterSequenceAtIndex:range.location];
        NSString *rangeString = [string substringWithRange:range];
        [reversed appendString:rangeString];
    }
    return reversed;
}

```
### Why I'm using this method
The following method is available in the Foundation framework, inside NSString class
```objective-c
- (NSRange)rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index;
```
It works with ranges, and giving an index in the string it builds a range with the location of the composed string and the length.
In the case of Emojis it's very easy to detect them, range returned is: {n,2}, where n is the location and 2 is the length.

### How to test:
You can try the tests in the IDTStringReverse target/folder source file: IDTStringReverse.m

```
Test Case '-[IDTStringReverse testReverseShortEmojiString]' started.
2016-09-24 12:05:07.118 UdpMobile[25667:7376015] abc = ae😄ou
2016-09-24 12:05:07.118 UdpMobile[25667:7376015] cba = uo😄ea
2016-09-24 12:05:07.118 UdpMobile[25667:7376015] abc2 = ae😄ou
```



## Non-ARC with double autorelease
* Explain what happens when the following code is executed (ARC being disabled in the compiler):

```objective-c
MyClass *myClass = [[[[MyClass alloc] init] autorelease] autorelease];
```
### Answer
Autorelease just decrements the receiver’s retain count at the end of the current autorelease pool block.
Any object sent an autorelease message inside the autorelease pool block is released at the end of the block.
malloc: *** error for object 0x10922ed40: pointer being freed was not allocated ***
It will crash. You are sending more than one autorelease, and the object after one autorelease was not allocated.
It's the same as:
```objective-c
MyClass *myClass = [[MyClass alloc] init]; 
[ball0 release];
[ball0 release];
```

## Implemented UDP
* Implement a UDP echo server on a desktop OS & programming language of choice (eg. some unix + python) and a UDP echo client (with UI!) for iOS to test your echo server.

### Answer

* Using the same IDTProject I've been implemented 2 applications that use the same Udp manager:
1. UdpMobile: it's an iOS app that send messages and waits receives responses from the server to know if the message is received.

![BackgroundImage](https://github.com/southfox/IDTProject/blob/master/ScreenShots/ScreenShot2.png)_
![BackgroundImage](https://github.com/southfox/IDTProject/blob/master/ScreenShots/ScreenShot3.png)_

2. UdpDesktop: it's a Mac OS app that shows 

![BackgroundImage](https://github.com/southfox/IDTProject/blob/master/ScreenShots/ScreenShot0.png)_
![BackgroundImage](https://github.com/southfox/IDTProject/blob/master/ScreenShots/ScreenShot1.png)_


The UdpManager is implemented using CocoaAsyncSocket, and is very easy to use, works with Mac OS and iOS at the same time. I've been testing with my Mac OS as a server and with iPad, iPhone 6, iPhone 5 and the Simulator.

## 3rd party components used in this project.

### CocoaSyncSocket (Mac OS and iOS)

https://cocoapods.org/pods/CocoaAsyncSocket
CocoaAsyncSocket provides easy-to-use and powerful asynchronous socket libraries for Mac and iOS. The classes are described below.

### libextobjc (Mac OS and iOS)

https://cocoapods.org/pods/libextobjc
pod 'libextobjc', '~> 0.4': @onExit, @stronfigy, @weakify are the extensions I'm using here, I found very usefull @onExit to clean up some memory, unsubscribe from observers, etc. @weakify/@strongify for to work easy and fast with weak variables in blocks and prevent retain cycles.

### SCLAlertView (only in iOS)

https://cocoapods.org/pods/SCLAlertView-Objective-C
- pod 'SCLAlertView-Objective-C', '~> 1.0': the alerts are really nice.
