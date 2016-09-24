//
//  IDTAutoreleaseNonArc.m
//  IDTAutoreleaseNonArc
//
//  Created by Javier Fuchs on 9/24/16.
//  Copyright © 2016 Fuchs. All rights reserved.
//

#import <XCTest/XCTest.h>
@interface MyClass : NSObject
@property (strong, nonatomic) NSString *buffer;
@end

@implementation MyClass
@end

@interface IDTAutoreleaseNonArc : XCTestCase

@end

@implementation IDTAutoreleaseNonArc

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExampleDoubleAutorelease {
    NSLog(@"%s:%d", __FUNCTION__, __LINE__);
    __unused MyClass *myClass = [[[[MyClass alloc] init] autorelease] autorelease];
    NSLog(@"%s:%d", __FUNCTION__, __LINE__);
}

@end
