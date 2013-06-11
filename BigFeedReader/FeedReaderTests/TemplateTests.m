//
//  TemplateTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-11.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "TemplateTests.h"
#import "Template.h"

@implementation TemplateTests

-(void)testInitWith
{
    Template * result = [[Template alloc]initWith:@"Template1"
        fromBundle: [NSBundle bundleForClass:[self class]]];
    STAssertNotNil(result, @"initWith returned nil");
}

-(void)testLoad
{
    Template * template = [[Template alloc]initWith:@"Template1"
                                       fromBundle: [NSBundle bundleForClass:[self class]]];
    NSString * result = [template load:@"{ foo:bar }"];
    
    STAssertEqualObjects(result,
                         @"var articleData = { foo:bar };",
                         @"load did not load the article correctly");
}

-(void)testLoadSubTemplate
{
    Template * template = [[Template alloc]initWith:@"Template2"
                                         fromBundle: [NSBundle bundleForClass:[self class]]];
    NSString * result = [template load:@"{ foo:f }"
                         subTemplate:@"SubTemplate1"];
    
    STAssertEqualObjects(result,
                         @"var articleData = { foo:f }; var templateData = { targets: [ ] };",
                         @"load:subTemplate did not load the subTemplate correctly");
}

@end
