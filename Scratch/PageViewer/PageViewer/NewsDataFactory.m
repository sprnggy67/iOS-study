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

-(void)test {
    NSObject *result = nil;
    
    NSString * str = @"[{\"id\": \"1\", \"name\":\"Aaa\"}, {\"id\": \"2\", \"name\":\"Bbb\"}]";
    result = [self parseString:str];
    NSLog(@"Result: %@", result);

    result = [self parseResource:@"ArticleList"];
    NSLog(@"Result: %@", result);
}

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
    NSError *e = nil;
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData: data options: NSJSONReadingMutableContainers error: &e];
    NSMutableArray * results = [[NSMutableArray alloc] initWithCapacity:10];
    
    if (!jsonArray) {
        NSLog(@"Error parsing JSON: %@", e);
        return nil;
    } else {
        for(NSDictionary *item in jsonArray) {
            [results addObject:[[Article alloc] initWithDictionary:item]];
        }
    }
    
    return results;
}

@end
