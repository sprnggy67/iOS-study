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

@synthesize bundle;
@synthesize dictionary;

#pragma mark - Init

-(id)initWithBundle:(NSBundle *)bundleParam {
    self = [super init];
    if (self) {
        self.bundle = bundleParam;
        self.dictionary = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Getters / Setters

-(Template *)template:(NSString *)name {
    // Look up the template.
    Template * result = nil;
    result = [dictionary objectForKey:name];
    if (result)
        return result;
    
    // If it doesn't exist, create it.
    result = [[Template alloc] initWith:name bundle:bundle];
    if (result) {
        [dictionary setObject:result forKey:name];
    }
    
    return result;
}

@end
