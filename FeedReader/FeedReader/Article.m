//
//  Article.m
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize templateName;
@synthesize headline;
@synthesize dictionary;
@synthesize jsonData;

+(Article *)articleFromDictionary:(NSDictionary *)dict {
    NSString * value;
    Article * article = [[Article alloc] init];
    if (article) {
        value = [dict valueForKey:@"headline"];
        if (value == nil) {
            NSLog(@"Article does not have a headline");
            return nil;
        }
        [article setHeadline:value];

        value = [dict valueForKey:@"templateName"];
        if (value == nil) {
            NSLog(@"Article does not have a templateName");
            return nil;
        }
        [article setTemplateName:value];
        
        [article setDictionary:dict];

        // Create a JSON version of the object for rendering time.
        NSError *e;
        NSData * data = [NSJSONSerialization dataWithJSONObject: dict options: NSJSONWritingPrettyPrinted error: &e];
        if (data == nil) {
            return nil;
        } else {
            [article setJsonData:[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]];
        }
    }
    return article;
}

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"Article %@, templateName %@, dictionary%@",
            self.headline,
            self.templateName,
            self.dictionary];
}


@end
