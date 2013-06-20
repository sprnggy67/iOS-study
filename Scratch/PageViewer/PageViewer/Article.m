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

// Initialize the object from a dictionary. The headline and templateName are retrieved from the dictionary.
-(id)initWithDictionary:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        [self setDictionary:dict];
        [self setTemplateName:[dict valueForKey:@"templateName"]];
        [self setHeadline:[dict valueForKey:@"headline"]];
        
        // Create a JSON version of the object for rendering time.
        // TODO: Find a more efficient way to do this. We currently read the data from a JSON, build the object, and then write the JSON again.
        // TODO: Add a catch for exceptions.
        NSError *e = nil;
        NSData * data = [NSJSONSerialization dataWithJSONObject: dict options: NSJSONWritingPrettyPrinted error: &e];
        [self setJsonData:[[NSString alloc] initWithData:data
                                                 encoding:NSUTF8StringEncoding]];
    }
    return self;
}

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"Article %@, templateName %@, dictionary%@",
            [self headline],
            [self templateName],
            [self dictionary]];
}


@end
