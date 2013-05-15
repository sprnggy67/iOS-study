//
//  NewsDataFactoryTests.m
//  FeedReader
//
//  Created by Dave on 2013-04-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "NewsDataFactoryTests.h"
#import "NewsDataFactory.h"

@implementation NewsDataFactoryTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testParseString
{
    NSObject *result = nil;
    NewsDataFactory * factory = [[NewsDataFactory alloc] init];
    
    NSString * str = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    result = [factory parseString:str];
    STAssertNotNil(result, @"parseString returned nil");
}

- (void)testParseResource
{
    NSObject *result = nil;
    NewsDataFactory * factory = [[NewsDataFactory alloc] init];
    
    result = [factory parseResource:@"ArticleList"];
    STAssertNotNil(result, @"parseResource returned nil");
}


@end
