//
//  Template.m
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Template.h"

@interface Template()

@property (strong, nonatomic) NSString * indexFile;

@end

@implementation Template

@synthesize name;
@synthesize indexFile;

NSString *const TEMPLATE_VARIABLE = @"JSON_DATA_VARIABLE";

-(id)initWith:(NSString *)nameParam {
    self = [super init];
    if (self) {
        [self setName:nameParam];
        if (![self loadIndexFile])
            return nil;
    }
    return self;
}

-(NSString *)load:(NSString *)contents {
    if (!foundRange)
        return indexFile;
    NSMutableString * result = [[NSMutableString alloc] initWithString:indexFile];
    [result replaceCharactersInRange:variableRange withString:contents];
    return result;
}

-(BOOL)loadIndexFile {
    // Load the file.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html" inDirectory:@"Templates"];
    self.indexFile = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (self.indexFile == nil) {
        NSLog(@"Unable to read file: %@", filePath);
        return NO;
    }
    
    // Split the file.
    variableRange = [indexFile rangeOfString:TEMPLATE_VARIABLE];
    if (variableRange.location == NSNotFound) {
        foundRange = NO;
        NSLog(@"Unable to find template variable: %@", filePath);
    } else {
        foundRange = YES;
    }
    
    return YES;
}

@end
