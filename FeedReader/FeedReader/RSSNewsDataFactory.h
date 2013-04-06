//
//  RSSNewsDataFactory.h
//  FeedReader
//
//  Created by Dave on 2013-03-27.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface RSSNewsDataFactory : NSObject <NSXMLParserDelegate>

+(void)test;

/*
 Parses a string and returns the articles within it
 */

-(NSArray *)parseString:(NSString*)str;

/*
 Loads a resource, parses it, and returns the articles within it
 */
-(NSArray *)parseResource:(NSString*)name;

/*
 Parses a data object and returns the articles within it
 */
-(NSArray *)parseData:(NSData*)data;

@end
