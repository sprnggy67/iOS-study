//
//  Template.h
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject {
    NSString * name;
    NSString * indexFile;
    NSRange variableRange;
}

@property (strong) NSString * name;

-(id)initWith:(NSString *)name;
-(NSString *)load:(NSString *)contents;

@end
