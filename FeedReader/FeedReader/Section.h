//
//  Section.h
//  FeedReader
//
//  Created by Dave on 2013-05-16.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Section : NSObject

@property (nonatomic, strong) NSString * name;
@property (assign) int start;
@property (assign) int length;

-(id)init:(NSString *)nameParam start:(int) startParam length:(int) lengthParam;

@end
