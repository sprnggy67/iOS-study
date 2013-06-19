//
//  RSSNewsDataFactoryTests.m
//  FeedReader
//
//  Created by Dave on 2013-04-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "RSSNewsDataFactoryTests.h"
#import "RSSNewsDataFactory.h"

@interface RSSNewsDataFactoryTests (Helpers)

-(void)compareArticle:(Article *)article toHeadline:(NSString *)headline template:(NSString *)template subTemplate:(NSString *)subTemplate;

@end

@implementation RSSNewsDataFactoryTests

- (void)testParseResource {
    // when
    NSArray *result = nil;
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    result = [factory parseResource:@"RSSFeed1" fromBundle: [NSBundle bundleForClass:[self class]]];
    
    // then
    STAssertNotNil(result, @"parseResource result is nil");
    STAssertEquals((int)[result count], 10, nil);
    
    // test each of the array objects
    [self compareArticle:[result objectAtIndex:0] toHeadline:@"Booch and Rum" template:@"dynamicTemplate" subTemplate: @"featureArticle"];
    [self compareArticle:[result objectAtIndex:1] toHeadline:@"You have to see it" template:@"dynamicTemplate" subTemplate: @"standardArticle"];
    [self compareArticle:[result objectAtIndex:2] toHeadline:@"The Times and Times" template:@"dynamicTemplate" subTemplate: @"standardArticle"];
    [self compareArticle:[result objectAtIndex:3] toHeadline:@"Titanium V PhoneGap" template:@"dynamicTemplate" subTemplate: @"standardArticle"];
    [self compareArticle:[result objectAtIndex:9] toHeadline:@"Request and Download Patterns" template:@"dynamicTemplate" subTemplate: @"standardArticle"];
}

-(void)compareArticle:(Article *)article toHeadline:(NSString *)headline template:(NSString *)template subTemplate:(NSString *)subTemplate
{
    NSRange range = [article.headline rangeOfString:headline];
    BOOL foundHeadline = (range.location != NSNotFound);
    STAssertTrue(foundHeadline, [NSString stringWithFormat:@"Could not find %@ in article.headline", article.headline]);
    
    if (template) {
        STAssertEqualObjects(article.templateName, template, article.headline);
    }
    
    if (subTemplate) {
        STAssertEqualObjects(article.subTemplateName, subTemplate, article.headline);
    }
}


@end
