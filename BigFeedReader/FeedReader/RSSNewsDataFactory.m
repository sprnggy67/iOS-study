//
//  RSSNewsDataFactory.m
//  FeedReader
//
//  Created by Dave on 2013-03-27.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "RSSNewsDataFactory.h"
#import "Article.h"

static int articleCount = 0;

@interface RSSNewsDataFactory ()
{
    BOOL inItem;
    BOOL debug;
    int count;
}

@property (strong, nonatomic) NSMutableArray * results;
@property (strong, nonatomic) NSMutableDictionary * currentArticleAttributes;
@property (strong, nonatomic) NSMutableString * currentStringValue;

@end

@implementation RSSNewsDataFactory

@synthesize results;
@synthesize currentArticleAttributes;
@synthesize currentStringValue;

#pragma mark - Parsers

// Converts a string into an array of articles.
-(NSArray *)parseString:(NSString*)str {
    NSData * data = [str dataUsingEncoding:NSUTF8StringEncoding];
    return [self parseData:data];
}

// Reads a set of articles from a resource.
-(NSArray *)parseResource:(NSString*)name fromBundle:(NSBundle *) bundle {
    NSString *filePath = [bundle pathForResource:name ofType:@"rss"];
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
    count = 0;
    
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
    if (debug)
        NSLog(@"didStartElement: %@", elementName);

    if ( [elementName isEqualToString:@"item"]) {
        inItem = TRUE;
        ++ articleCount;
        self.currentArticleAttributes = [[NSMutableDictionary alloc] init];
        [currentArticleAttributes setObject:[NSString stringWithFormat:@"Article %i", articleCount] forKey:@"id"];
        [currentArticleAttributes setObject:@"dynamicTemplate" forKey:@"templateName"];
        if (count == 0) {
            [currentArticleAttributes setObject:@"featureArticle" forKey:@"subTemplateName"];
        } else {
            [currentArticleAttributes setObject:@"standardArticle" forKey:@"subTemplateName"];
        }
        count ++;
        return;
    }
    
    self.currentStringValue = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if (debug)
        NSLog(@"foundCharacters: %@", string);

    [self.currentStringValue appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI
    qualifiedName:(NSString *)qName
{
    if (debug) {
        NSLog(@"didEndElement: %@", elementName);
        NSLog(@"The currentStringValue is: %@", self.currentStringValue);
    }
    
    if ( [elementName isEqualToString:@"item"] ) {
        Article * article = [Article articleFromDictionary:currentArticleAttributes];
        if (article != NULL) {
            [results addObject:article];
            if (debug) {
                NSLog(@"Found article %@", [article headline]);
            }
        } else {
            NSLog(@"Could not parse article %@", currentArticleAttributes);
        }
        self.currentArticleAttributes = nil;
        inItem = FALSE;
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"title"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"headline"];
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"pubDate"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"pubDate"];
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"content:encoded"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"body"];
        return;
    }

    if ( inItem && [elementName isEqualToString:@"description"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"standFirst"];
        return;
    }
      
    if ( inItem && [elementName isEqualToString:@"author"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"byline"];
        return;
    }
    
    if ( inItem && [elementName isEqualToString:@"dc:creator"] ) {
        [currentArticleAttributes setObject:currentStringValue forKey:@"byline"];
        return;
    }
    
    self.currentStringValue = [[NSMutableString alloc] init];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"Parse error: %@", parseError);
}

- (void)parser:(NSXMLParser *)parser validationErrorOccurred:(NSError *)validError {
    NSLog(@"Validation error: %@", validError);
    
}


@end
