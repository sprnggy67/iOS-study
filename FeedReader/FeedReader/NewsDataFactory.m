//
//  NewsDataFactory.m
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "NewsDataFactory.h"
#import "Article.h"

@implementation NewsDataFactory

#pragma mark - Test

+(void)test {
    NSObject *result = nil;
    NewsDataFactory * factory = [[NewsDataFactory alloc] init];
    
    NSString * str = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    result = [factory parseString:str];
    NSLog(@"Result: %@", result);

    result = [factory parseResource:@"ArticleList"];
    NSLog(@"Result: %@", result);
}

#pragma mark - Parsers

// Converts a string into an array of articles.
-(NSArray *)parseString:(NSString*)str {
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [self parse:data];
}

// Reads a set of articles from a resource.
-(NSArray *)parseResource:(NSString*)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        NSLog(@"Unable to read file: %@", filePath);
        return nil;
    }
    return [self parse:data];    
}

-(NSArray *)parse:(NSData*)data {
    NSError *e;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
        return nil;
    } else {
        NSMutableArray * results = [[NSMutableArray alloc] initWithCapacity:10];
        for (NSDictionary *item in jsonArray) {
            Article * article = [Article articleFromDictionary:item];
            if (article != nil) {
                [results addObject:article];
            } else {
                NSLog(@"Unable to parse article");
            }
        }
        return results;
    }
}

@end
