IDT test
========

# Objective
Implementation in Objective-C. The code is documented answering "why" (more important than "what"). 

# Porpuse
3 objetives

## Reverse method
1. Function which takes a string as argument and returns the string reversed. For example, "abcdef" becomes "fedcba". Not using the reverse method. It work with emojis.
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


### Answer

## Non-ARC with double autorelease
2. Explain what happens when the following code is executed (ARC being disabled in the compiler):

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
5. Implement a UDP echo server on a desktop OS & programming language of choice (eg. some unix + python) and a UDP echo client (with UI!) for iOS to test your echo server.

### Answer

## 3rd party components
