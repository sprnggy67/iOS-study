//
//  ArticleCoreDataTests.m
//  FeedReader
//
//  Created by Dave on 2013-08-05.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ArticleCoreDataTests.h"
#import "ArticleOverview.h"
#import "ArticleDetails.h"

@implementation ArticleCoreDataTests
{
    ArticleCoreData * coreData;
    NSString * fileName;
}

- (void)setUp {
    fileName = @"TestAllocInit.sqlite";
    coreData = [[ArticleCoreData alloc] initWithName:fileName];
    [coreData setStoreType: NSInMemoryStoreType];
}

- (void)tearDown {
    [coreData deleteAllData];
    NSError * error;
    [coreData save:&error];
}

- (void)testInitWithName
{
    // Given coredata.
    
    // Then
    STAssertNotNil(coreData, @"alloc init returned nil");
    STAssertEquals(coreData.fileName, fileName, @"invalid fileName");
}

- (void)testCreateArticleOverview
{
    // Given
    NSString * uniqueId = [[NSDate date] description];
    
    // When
    ArticleOverview * overview = [coreData createArticleOverview];
    overview.headline = @"Foo";
    overview.uniqueId = uniqueId;
    [coreData save:nil];
    
    // Then
    NSArray * data = [coreData articleOverviewData];
    STAssertNotNil(overview, @"createArticleDetails returned nil");
    STAssertEquals((int)[data count], 1, @"core data must contain 1 item");
    overview = [data objectAtIndex:0];
    STAssertEquals(overview.uniqueId, uniqueId, @"invalid uniqueId");
}

- (void)testCreateTwoArticleOverviews
{
    // Given
    NSString * uniqueId1 = @"One";
    NSString * uniqueId2 = @"Two";
    
    // When
    ArticleOverview * overview = [coreData createArticleOverview];
    overview.uniqueId = uniqueId1;
    overview = [coreData createArticleOverview];
    overview.uniqueId = uniqueId2;
    [coreData save:nil];
    
    // Then
    NSArray * data = [coreData articleOverviewData];
    STAssertNotNil(overview, @"createArticleDetails returned nil");
    STAssertEquals((int)[data count], 2, @"core data must contain 2 item");
    overview = [data objectAtIndex:0];
    STAssertEqualObjects(overview.uniqueId, uniqueId1, nil);
    overview = [data objectAtIndex:1];
    STAssertEqualObjects(overview.uniqueId, uniqueId2, nil);
}

- (void)testCreateArticleOverviewAndDetail
{
    // Given.
    NSString * uniqueId1 = [[NSDate date] description];
    
    // When
    ArticleOverview * overview = [coreData createArticleOverview];
    overview.uniqueId = uniqueId1;
    ArticleDetails * details = [coreData createArticleDetails];
    details.templateName = @"template1";
    details.subTemplateName = @"subTemplate1";
    details.jsonData = @"{ }";
    overview.details = details;
    [coreData save:nil];
    
    // Then
    NSArray * data = [coreData articleOverviewData];
    STAssertNotNil(overview, @"createArticleDetails returned nil");
    STAssertEquals((int)[data count], 1, @"core data must contain 1 item");
    overview = [data objectAtIndex:0];
    STAssertEquals(overview.uniqueId, uniqueId1, @"invalid uniqueId");
    STAssertNotNil(overview.details, @"overview.details is nil");
    details = overview.details;
    STAssertEquals(details.templateName, @"template1", @"invalid template name");
    STAssertEquals(details.subTemplateName, @"subTemplate1", @"invalid sub template name");
    STAssertEquals(details.jsonData, @"{ }", @"invalid json");
}


- (void)testDeleteAllData
{
    // Given
    [coreData createArticleOverview];
    
    // When
    [coreData deleteAllData];
    
    // Then
    NSArray * data = [coreData articleOverviewData];
    STAssertEquals((int)[data count], 0, @"core data must be empty");
}

- (void)testArticleOverviewDataIsInitiallyEmpty
{
    // Given
    NSArray * data = [coreData articleOverviewData];
    
    // Then
    STAssertNotNil(data, @"alloc init returned nil");
    STAssertEquals((int)[data count], 0, @"article overview data is not empty");
}


@end
