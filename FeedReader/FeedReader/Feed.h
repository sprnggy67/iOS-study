//
//  Feed.h
//
//  A single feed.  A feed is used to supply article data.
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * url;

/*
 Creates a feed from a dictionary. 
 The dictionary is typically created using toDictionary.
 */
+(Feed *)feedFromDictionary:(NSDictionary *)dictionary;

/*
 Initialises a feed with a name and url.
 */
-(id)initWithName:(NSString *)nameParam url:(NSString *)urlParam;

/*
 Returns a dictionary representation of a feed for persistence purposes
 */
-(NSDictionary *)toDictionary;

@end
