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

// Initialize the object from a dictionary. The headline and templateName are retrieved from the dictionary.
+(Article *)articleFromDictionary:(NSDictionary *)dict {
    Article * article = [[Article alloc] init];
    if (article) {
        [article setDictionary:dict];
        [article setTemplateName:[dict valueForKey:@"templateName"]];
        [article setHeadline:[dict valueForKey:@"headline"]];
        
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
