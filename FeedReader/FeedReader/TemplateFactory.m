//
//  TemplateFactory.m
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "TemplateFactory.h"

@interface TemplateFactory()

@property (strong, nonatomic) NSMutableDictionary * dictionary;

@end

@implementation TemplateFactory

@synthesize dictionary;

-(id)init {
    self = [super init];
    if (self) {
        self.dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

-(Template *)template:(NSString *)name {
    // Look up the template.
    Template * result = nil;
    result = [dictionary objectForKey:name];
    if (result)
        return result;
    
    // If it doesn't exist, create it.
    result = [[Template alloc] initWith:name];
    if (result) {
        [dictionary setObject:result forKey:name];
    }
    
    return result;
}

@end
