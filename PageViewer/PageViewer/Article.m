//
//  Article.m
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Article.h"

@implementation Article
{
    
}

@synthesize templateName, headline, dictionary, jsonData;

-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setDictionary:dict];
        [self setTemplateName:[dict valueForKey:@"templateName"]];
        [self setHeadline:[dict valueForKey:@"headline"]];
        
        NSError *e = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject: dict options: NSJSONWritingPrettyPrinted error: &e];
        [self setJsonData:[[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding]];
    }
    return self;
}

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"Article %@, template %@, dictionary%@",
            [self headline],
            [self templateName],
            [self dictionary]];
}


@end
