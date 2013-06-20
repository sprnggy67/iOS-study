//
//  Section.m
//  FeedReader
//
//  Created by Dave on 2013-05-16.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Section.h"

@implementation Section

@synthesize name;
@synthesize start;
@synthesize length;

-(id) init:(NSString *)nameParam start:(int) startParam length:(int) lengthParam {
    self = [super init];
    if (self) {
        self.name = nameParam;
        self.start = startParam;
        self.length = lengthParam;
    }
    return self;
}

@end
