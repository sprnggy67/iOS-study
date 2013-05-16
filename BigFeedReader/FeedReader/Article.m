//
//  Article.m
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Article.h"

@implementation Article

@synthesize source;
@synthesize templateName;
@synthesize headline;
@synthesize jsonData;
@synthesize pubDate;

#pragma mark - Init

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
        if (value != nil) {
            [article setTemplateName:value];
        }

        value = [dict valueForKey:@"pubDate"];
        if (value != nil) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss ZZ"];
            NSDate *date;
            NSError *error;
            if ([dateFormatter getObjectValue:&date forString:value range:nil error:&error]) {
                [article setPubDate:date];
            } else {
                NSLog(@"Date '%@' could not be parsed: %@", value, error);
            }
        }

        // Create a JSON version of the object for rendering time.
        NSError *e;
        NSData * data = [NSJSONSerialization dataWithJSONObject: dict options: NSJSONWritingPrettyPrinted error: &e];
        if (data == nil) {
            NSLog(@"Could not serialize json.  Error: %@", e);
            return nil;
        } else {
            [article setJsonData:[[NSString alloc] initWithData:data
                                                     encoding:NSUTF8StringEncoding]];
        }
    }
    return article;
}

/*
 Creates an navigation article from a set of child articles.
 */
+(Article *)articleWithHeadline:(NSString *)headline template:(NSString *)templateName withChildren:(NSArray *)children {
    Article * article = [[Article alloc] init];
    if (article) {
        // Store the key properties
        [article setHeadline:headline];
        [article setTemplateName:templateName];
        [article setPubDate:[NSDate date]];
        
        // Generate the json data.
        NSMutableString * jsonData = [[NSMutableString alloc] init];
        [jsonData appendString:@"{"];
        [jsonData appendFormat:@"\"headline\":\'%@\',", headline];
        [jsonData appendFormat:@"\"children\":["];
        for (Article * child in children) {
            NSString * json = child.jsonData;
            [jsonData appendString:json];
            [jsonData appendFormat:@","];
        }
        [jsonData appendFormat:@"]"];
        [jsonData appendFormat:@"}"];
        [article setJsonData:jsonData];
    }
    return article;
}


#pragma mark - Utility

- (NSComparisonResult)compare:(Article *)otherObject {
    if (self.pubDate != nil && otherObject.pubDate != nil)
        return [self.pubDate compare:otherObject.pubDate];
    else
        return [self.headline compare:otherObject.headline];
}

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"Article %@, templateName %@",
            self.headline,
            self.templateName];
}


@end
