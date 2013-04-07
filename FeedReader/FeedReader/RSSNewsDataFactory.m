//
//  RSSNewsDataFactory.m
//  FeedReader
//
//  Created by Dave on 2013-03-27.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "RSSNewsDataFactory.h"
#import "Article.h"

@interface RSSNewsDataFactory ()
{
    BOOL inItem;
}

@property (strong, nonatomic) NSMutableArray * results;
@property (strong, nonatomic) NSMutableDictionary * currentArticleAttributes;
@property (strong, nonatomic) NSString * currentStringValue;

@end

@implementation RSSNewsDataFactory

@synthesize results;
@synthesize currentArticleAttributes;
@synthesize currentStringValue;

#pragma mark - Test

+(void)test {
    NSObject *result = nil;
    RSSNewsDataFactory * factory = [[RSSNewsDataFactory alloc] init];
    result = [factory parseResource:@"ArticleList"];
    NSLog(@"Result: %@", result);
}

#pragma mark - Parsers

// Converts a string into an array of articles.
-(NSArray *)parseString:(NSString*)str {
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [self parseData:data];
}

// Reads a set of articles from a resource.
-(NSArray *)parseResource:(NSString*)name {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"rss"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    if (data == nil) {
        NSLog(@"Unable to read file: %@", filePath);
        return nil;
    }
    return [self parseData:data];
}

-(NSArray *)parseData:(NSData*)data {
    // Init the result data.
    self.results = [[NSMutableArray alloc] initWithCapacity:10];
    self.currentArticleAttributes = nil;
    self.currentStringValue = nil;
    inItem = FALSE;
    
    // Initialize the parser
    NSXMLParser * parser = [[NSXMLParser alloc] initWithData:data];
    if (parser == nil) {
        NSLog(@"Unable to init parser");
        return nil;
    }
    [parser setDelegate:self];

    // Run the parser
    BOOL success = [parser parse];
    if (!success) {
        NSLog(@"Unable to parse data");
        return nil;
    }
    
    // Return the result data
    return results;
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ( [elementName isEqualToString:@"item"]) {
        inItem = TRUE;
        self.currentArticleAttributes = [[NSMutableDictionary alloc] init];
        [currentArticleAttributes setObject:@"ArticleTemplate" forKey:@"templateName"];
        return;
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    self.currentStringValue = string;
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    if ( [elementName isEqualToString:@"item"] ) {
        Article * article = [Article articleFromDictionary:currentArticleAttributes];
        if (article != NULL) {
            [results addObject:article];
            NSLog(@"Found article %@", [article headline]);
        } else {
            NSLog(@"Could not parse article");
        }
        self.currentArticleAttributes = nil;
        inItem = FALSE;
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"title"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"headline"];
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"content:encoded"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"body"];
        return;
    }

    self.currentStringValue = nil;
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
    NSLog(@"Validation error: %@", validError);
    
}


@end
