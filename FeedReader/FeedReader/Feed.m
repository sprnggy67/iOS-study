//
//  Feed.m
//  FeedReader
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Feed.h"

@implementation Feed

@synthesize name;
@synthesize url;

+(Feed *)feedFromDictionary:(NSDictionary *)dictionary {
    NSString * name = [dictionary objectForKey:@"name"];
    NSString * url = [dictionary objectForKey:@"url"];
    if (name == nil || url == nil) {
        NSLog(@"Could not find name or url in dictionary");
        return nil;
    }
    return [[Feed alloc] initWithName:name url:url];
}

-(id)initWithName:(NSString *)nameParam url:(NSString *)urlParam {
    self = [super init];
    if (self) {
        self.name = nameParam;
        self.url = urlParam;
    }
    return self;
}

-(NSDictionary *)toDictionary {
    NSMutableDictionary * result = [[NSMutableDictionary alloc] init];
    [result setObject:self.name forKey:@"name"];
    [result setObject:self.url forKey:@"url"];
    return result;
}


@end
