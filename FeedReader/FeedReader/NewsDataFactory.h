//
//  NewsDataFactory.h
//
//  Generates a set of news articles from a JSON file
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

// Generates an array of articles from a resource file
@interface NewsDataFactory : NSObject

+(void)test;

/*
 Parses a string to return an array of articles
 */
-(NSArray *)parseString:(NSString*)str;

/*
 Reads a resource file and returns an array of articles.
 */
-(NSArray *)parseResource:(NSString*)name;

@end
