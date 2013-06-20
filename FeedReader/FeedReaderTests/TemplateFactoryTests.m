//
//  TemplateFactoryTests.m
//  FeedReader
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "TemplateFactoryTests.h"
#import "TemplateFactory.h"

@implementation TemplateFactoryTests

-(void)testInitWithBundle
{
    TemplateFactory * factory = [[TemplateFactory alloc] initWithBundle:[NSBundle bundleForClass:[self class]]];
    STAssertNotNil(factory, @"initWithBundle returned nil");
}

-(void)testTemplate1
{
    TemplateFactory * factory = [[TemplateFactory alloc] initWithBundle:[NSBundle bundleForClass:[self class]]];
    Template * template = [factory template:@"Template1"];
    
    STAssertEquals(template.name, @"Template1", @"template name is incorrect");
}

-(void)testTemplate1ReturnsConstantValue
{
    TemplateFactory * factory = [[TemplateFactory alloc] initWithBundle:[NSBundle bundleForClass:[self class]]];
    Template * template1 = [factory template:@"Template1"];
    Template * template2 = [factory template:@"Template1"];
    
    STAssertEqualObjects(template1, template2, @"successive calls to template must return the same value");
}

-(void)testTemplate2
{
    TemplateFactory * factory = [[TemplateFactory alloc] initWithBundle:[NSBundle bundleForClass:[self class]]];
    Template * template = [factory template:@"Template2"];
    
    STAssertEquals(template.name, @"Template2", @"template name is incorrect");
}


@end
