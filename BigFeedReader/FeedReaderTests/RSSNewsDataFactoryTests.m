//
//  RSSNewsDataFactoryTests.m
//  FeedReader
//
//  Created by Dave on 2013-04-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "RSSNewsDataFactoryTests.h"
#import "RSSNewsDataFactory.h"

@implementation RSSNewsDataFactoryTests

- (void)testParseResource {
    NSObject *result = nil;
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    result = [factory parseResource:@"RSSFeed1" fromBundle: [NSBundle bundleForClass:[self class]]];
    STAssertNotNil(result, @"parseResource result is nil");
}


@end
