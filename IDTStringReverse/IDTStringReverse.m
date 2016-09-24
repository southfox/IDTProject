//
//  IDTStringReverse.m
//  IDTStringReverse
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface IDTStringReverse : XCTestCase


@end

@implementation IDTStringReverse

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testReverseNilString {
    NSString *abc = nil;
    NSString *cba = [self reverseStringObjC:abc];
    XCTAssertNil(cba);
    XCTAssertFalse([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    XCTAssertNil(abc2);
    XCTAssertFalse([abc2 isEqualToString:cba]);
    XCTAssertFalse([abc2 isEqualToString:abc]);
}

- (void)testReverseOneString {
    NSString *abc = @"a";
    NSString *cba = [self reverseStringObjC:abc];
    XCTAssertNotNil(cba);
    XCTAssertTrue([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    XCTAssertNotNil(abc2);
    XCTAssertTrue([abc2 isEqualToString:cba]);
    XCTAssertTrue([abc2 isEqualToString:abc]);
}

- (void)testReverseShortString {
    NSString *abc = @"abc";
    NSString *cba = [self reverseStringObjC:abc];
    XCTAssertNotNil(cba);
    XCTAssertFalse([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    XCTAssertNotNil(abc2);
    XCTAssertFalse([abc2 isEqualToString:cba]);
    XCTAssertTrue([abc2 isEqualToString:abc]);
    
}

- (void)testReverseLongString {
    NSString *abc = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789 ABCDEFGHIJKLMNOPQRSTUVWXYZABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789";
    NSLog(@"abc = %@", abc);
    NSString *cba = [self reverseStringObjC:abc];
    NSLog(@"cba = %@", cba);
    XCTAssertNotNil(cba);
    XCTAssertFalse([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    NSLog(@"abc2 = %@", abc2);
    XCTAssertNotNil(abc2);
    XCTAssertFalse([abc2 isEqualToString:cba]);
    XCTAssertTrue([abc2 isEqualToString:abc]);
}

- (void)testReverseUnicodesString {
    NSString *abc = @"!~`@#$%^&*-+();:=_{}[],.<>?\\/|\"\'€ß⁄‹›ﬁﬂ‡°·‚—±»’”∏Øˆ¨Áˇ‰´„ŒÅÍÎÏ˝ÓÔÒÚÆ¿˘¯Â˜ı◊Ç˛¸Ω≈ç√∫˜µ≤≥÷æ…¬˚∆˙©ƒ∂ßåœ∑´®†¥¨ˆøπ“‘«≠–ºª•¶§∞¢£™¡";
    NSLog(@"abc = %@", abc);
    NSString *cba = [self reverseStringObjC:abc];
    NSLog(@"cba = %@", cba);
    XCTAssertNotNil(cba);
    XCTAssertFalse([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    XCTAssertNotNil(abc2);
    XCTAssertFalse([abc2 isEqualToString:cba]);
    XCTAssertTrue([abc2 isEqualToString:abc]);
    NSLog(@"abc2 = %@", abc2);
}

- (void)testReverseShortEmojiString {
    NSString *abc = @"ae😄ou";
    NSLog(@"abc = %@", abc);
    NSString *cba = [self reverseStringObjC:abc];
    NSLog(@"cba = %@", cba);
    XCTAssertNotNil(cba);
    XCTAssertFalse([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    NSLog(@"abc2 = %@", abc2);
    XCTAssertNotNil(abc2);
    XCTAssertFalse([abc2 isEqualToString:cba]);
    XCTAssertTrue([abc2 isEqualToString:abc]);
}

- (void)testReverseLongEmojiString {
    NSString *abc = @"😘bcd😀fgh😅jklmn😲pqrst👿vwxyz💢BCD✊FGH🚶JKLKMN👵PQRST😼VWXYZ0123456789 💧BCD☔FGH🌊JKLMN🐸PQRST🐦VWXYZ🐞BCD🐏FGH🐂JKLKMN🌹PQRST🌚VWXYZ0123456789";
    NSLog(@"abc = %@", abc);
    NSString *cba = [self reverseStringObjC:abc];
    NSLog(@"cba = %@", cba);
    XCTAssertNotNil(cba);
    XCTAssertFalse([abc isEqualToString:cba]);
    NSString *abc2 = [self reverseStringObjC:cba];
    NSLog(@"abc2 = %@", abc2);
    XCTAssertNotNil(abc2);
    XCTAssertFalse([abc2 isEqualToString:cba]);
    XCTAssertTrue([abc2 isEqualToString:abc]);
}

/// Reverse string method using Objective-C
/// Suports unicode and emoji characters
/// @param receives an string
- (NSString *)reverseStringObjC:(NSString *)string
{
    // take the length of the string to use in more than one place in the function
    unsigned long lenOfString = string.length;
    
    // empty string or with one character are not reversible
    if (!string || lenOfString == 1) {
        return string;
    }
    
    // create a new mutable string in memory to return after the algorithm
    NSMutableString *reversed = [[NSMutableString alloc] init];
    
    // traverse the string from end to start
    // working with range is just because I'm using rangeOfComposedCharacterSequenceAtIndex
    // It's appropiate in this case.
    for (NSRange range = NSMakeRange(lenOfString-1, 1);
         (int)range.location >= 0;
         range.location--)
    {
        // This method returns the range of the composed character (Emoji's are that)
        // At the same time I'm overriding the local cycle variable "range" with the current
        // founded range.
        range = [string rangeOfComposedCharacterSequenceAtIndex:range.location];
        
        // Here we get the string inside the range
        // In the case of normal char/uchar it will return the range with length = 1
        // In the case of Emojis length normally is 2
        NSString *rangeString = [string substringWithRange:range];
        
        // Append composed string in reverse order inside the new string to return
        [reversed appendString:rangeString];
    }
    // string is reversed here
    return reversed;
}



@end
