//
//  Article.h
//
//  A story or article, consisting of a headline, template reference and additional JSON data.
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject

@property (nonatomic, strong) NSString * source;
@property (nonatomic, strong) NSString * templateName;
@property (nonatomic, strong) NSString * headline;
@property (nonatomic, strong) NSString * jsonData;
@property (nonatomic, strong) NSDictionary * dictionary;
@property (nonatomic, strong) NSDate * pubDate;

/*
 Creates an article from a dictionary. 
 The dictionary must contain key value pairs for the headline, content, and templateName
 */
+(Article *)articleFromDictionary:(NSDictionary *)dictionary;

/*
 Compares one article to another
 */
- (NSComparisonResult)compare:(Article *)otherObject;

@end
