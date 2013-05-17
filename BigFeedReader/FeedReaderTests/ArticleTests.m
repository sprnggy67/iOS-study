//
//  ArticleTests.m
//  FeedReader
//
//  Created by Dave on 2013-05-16.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ArticleTests.h"
#import "Article.h"

@implementation ArticleTests

+ (NSMutableDictionary *) createArticleDict:(NSString *)headline template:(NSString *)template standFirst:(NSString *)sf body:(NSString *) body {
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:10];
    [dict setValue:headline forKey:@"headline"];
    [dict setValue:template forKey:@"templateName"];
    [dict setValue:sf forKey:@"standFirst"];
    [dict setValue:body forKey:@"body"];
    [dict setValue:@"Dave" forKey:@"byline"];
    return dict;
}

+ (Article *) createArticle:(NSString *)headline template:(NSString *)template standFirst:(NSString *)sf body:(NSString *) body {
    NSDictionary * dict = [ArticleTests createArticleDict:headline
                                                 template:template
                                               standFirst:sf
                                                     body:body];
    return [Article articleFromDictionary:dict];
}

- (void)testArticleFromDictionary
{
    // Create test data.
    NSDictionary * dict = [ArticleTests createArticleDict:@"h1"
                                                 template:@"t1"
                                               standFirst:@"sf1"
                                                     body:@"body1"];
    // Create an article.
    Article * result = [Article articleFromDictionary:dict];

    // Test the article.
    STAssertNotNil(result, @"articleFromDictionary returned nil");
    STAssertEqualObjects(result.headline, @"h1", @"headline is incorrect");
    STAssertEqualObjects(result.templateName, @"t1", @"template is incorrect");
    STAssertNotNil(result.jsonData, @"jsonData is nil");
}

- (void)testArticleWithHeadline
{
    // Create test data.
    Article * child1 = [ArticleTests createArticle:@"h1"
                                          template:nil
                                        standFirst:@"sf1"
                                              body:@"body1"];
    
    Article * child2 = [ArticleTests createArticle:@"h2"
                                          template:nil
                                        standFirst:@"sf2"
                                              body:@"body2"];
    
    NSArray * children = [NSArray arrayWithObjects:child1, child2, nil];

    // Create the article.
    Article * result = [Article articleWithHeadline:@"best of times"
                                           template:@"dynamicTemplate"
                                        subTemplate:@"bestOfTimes"
                                       withChildren:children];

    // Test the article.
    STAssertNotNil(result, @"articleWithHeadline returned nil");
    STAssertEqualObjects(result.headline, @"best of times", @"headline is incorrect");
    STAssertEqualObjects(result.templateName, @"dynamicTemplate", @"template is incorrect");
    STAssertEqualObjects(result.subTemplateName, @"bestOfTimes", @"template is incorrect");
    STAssertNotNil(result.jsonData, @"jsonData is nil");
}

@end
