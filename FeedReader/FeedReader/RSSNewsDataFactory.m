//
//  RSSNewsDataFactory.m
//  FeedReader
//
//  Created by Dave on 2013-03-27.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "RSSNewsDataFactory.h"
#import "Article.h"

@implementation RSSNewsDataFactory

@synthesize currentArticleAttributes;
@synthesize currentStringValue;

-(void)test {
    NSObject *result = nil;
    
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
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"rss"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        NSLog(@"Unable to read file: %@", filePath);
        return nil;
    }
    return [self parse:data];
}

-(NSArray *)parse:(NSData*)data {
    // Init the result data.
    results = [[NSMutableArray alloc] initWithCapacity:10];
    currentArticleAttributes = nil;
    currentStringValue = nil;
    inItem = FALSE;
    
    // Run the parser
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
    [parser setDelegate:self];
    BOOL success = [parser parse]; // return value not used
        // if not successful, delegate is informed of error
    
    // Return the result data
    return results;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [elementName isEqualToString:@"item"]) {
        inItem = TRUE;
        currentArticleAttributes = [[NSMutableDictionary alloc] init];
        [currentArticleAttributes setObject:@"ArticleTemplate" forKey:@"templateName"];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    currentStringValue = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    if ( [elementName isEqualToString:@"item"] ) {
        Article * article = [[Article alloc] initWithDictionary:currentArticleAttributes];
        if (article != NULL) {
            [results addObject:article];
            NSLog(@"Found article %@", [article headline]);
        } else {
            NSLog(@"Could not parse article");
        }
        currentArticleAttributes = nil;
        inItem = FALSE;
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"title"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"headline"];
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"description"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"body"];
        return;
    }

    currentStringValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
    NSLog(@"Validation error: %@", validError);
    
}


@end
