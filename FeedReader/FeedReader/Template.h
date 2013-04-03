//
//  Template.h
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

// An HTML5 template, used to define the presentation of an article.
@interface Template : NSObject

@property (strong, nonatomic) NSString * name;

-(id)initWith:(NSString *)name;
-(NSString *)load:(NSString *)contents;

@end
