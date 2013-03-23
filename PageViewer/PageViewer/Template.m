//
//  Template.m
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Template.h"

@implementation Template

@synthesize name;

NSString *const TEMPLATE_VARIABLE = @"JSON_DATA_VARIABLE";

-(id)initWith:(NSString *)nameParam {
    self = [super init];
    if (self) {
        [self setName:nameParam];
        if (![self loadIndexFile])
            return NULL;
    }
    return self;
}

-(NSString *)load:(NSString *)contents {
    NSMutableString * result = [[NSMutableString alloc] initWithString:indexFile];
    [result replaceCharactersInRange:variableRange withString:contents];
    return result;
}

-(BOOL)loadIndexFile {
    // Load the file.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html" inDirectory:@"Templates"];
    indexFile = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (indexFile == NULL) {
        NSLog(@"Unable to read file: %@", filePath);
        return NO;
    }
    
    // Split the file.
    variableRange = [indexFile rangeOfString:TEMPLATE_VARIABLE];
    if (variableRange.location == NSNotFound) {
        NSLog(@"Unable to find template variable: %@", filePath);
        return NO;
    }
    
    return YES;
}


@end
