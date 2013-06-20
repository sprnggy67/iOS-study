//
//  Article.h
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Article : NSObject
{
    NSString * _headline;
    NSString * _standfirst;
    NSString * _body;
    NSDictionary * _dictionary;
}

@property (nonatomic, strong) NSString * headline;
@property (nonatomic, strong) NSString * standfirst;
@property (nonatomic, strong) NSString * body;
@property (nonatomic, strong) NSDictionary * dictionary;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
