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
    NSString * templateName;
    NSString * headline;
    NSString * jsonData;
    NSDictionary * dictionary;
}

@property (nonatomic, strong) NSString * templateName;
@property (nonatomic, strong) NSString * headline;
@property (nonatomic, strong) NSString * jsonData;
@property (nonatomic, strong) NSDictionary * dictionary;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
