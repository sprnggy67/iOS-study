//
//  Feed.h
//  FeedReader
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Feed : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSString * url;

+(Feed *)feedFromDictionary:(NSDictionary *)dictionary;

-(id)initWithName:(NSString *)nameParam url:(NSString *)urlParam;
-(NSDictionary *)toDictionary;

@end
