//
//  SectionTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "SectionTests.h"
#import "Section.h"

@implementation SectionTests

- (void)testInit
{
    // Create test data.
    NSString * name = @"Section 1";
    Section * result = [[Section alloc] init:name
                                       start:40
                                      length:20];
    
    // Test the data.
    STAssertNotNil(result, @"init returned nil");
    STAssertEqualObjects(result.name, name, @"name is incorrect");
    STAssertEquals(result.start, 40, @"start is incorrect");
    STAssertEquals(result.length, 20, @"length is incorrect");
}


@end
