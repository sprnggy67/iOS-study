//
//  Article.m
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Article.h"

@implementation Article
{
    
}

@synthesize headline = _headline;
@synthesize standfirst = _standfirst;
@synthesize body = _body;
@synthesize dictionary = _dictionary;

-(id)initWithDictionary:(NSDictionary *)dictionary {
    [self setDictionary:dictionary];
    [self setHeadline:[dictionary valueForKey:@"headline"]];
    [self setStandfirst:[dictionary valueForKey:@"standfirst"]];
    [self setBody:[dictionary valueForKey:@"body"]];
    return self;
}

-(NSString *)description {
    return [[NSString alloc] initWithFormat:@"Article %@, dictionary%@",
            [self headline],
            [self dictionary]];
}


@end
