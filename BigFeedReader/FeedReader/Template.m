//
//  Template.m
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "Template.h"

@interface Template() {
    BOOL foundRange;
    NSRange variableRange;
}

@property (strong, nonatomic) NSString * indexFile;

@end

@implementation Template

@synthesize name;
@synthesize indexFile;

NSString *const JSON_DATA_VARIABLE = @"JSON_DATA_VARIABLE";
NSString *const TEMPLATE_DATA_VARIABLE = @"TEMPLATE_DATA_VARIABLE";

#pragma mark - Init

/*
 Creates a new template with a name.
 The template itself will be loaded (eventually) from a file called name.html in the Supporting Files.
 */
-(id)initWith:(NSString *)nameParam {
    self = [super init];
    if (self) {
        self.name = nameParam;
        if (![self loadIndexFile])
            return nil;
    }
    return self;
}


-(NSString *)load:(NSString *)contents {
    return [self load:contents subTemplate:NULL];
}

-(NSString *)load:(NSString *)contents subTemplate:(NSString *)subTemplateName {
    if (!foundRange)
        return indexFile;
    
    // Replace the json data
    NSMutableString * result = [[NSMutableString alloc] initWithString:indexFile];
    [result replaceCharactersInRange:variableRange withString:contents];
    
    // Replace the template data
    if (subTemplateName != NULL) {
        NSRange templateVarRange = [result rangeOfString:TEMPLATE_DATA_VARIABLE];
        if (templateVarRange.location != NSNotFound) {
            NSString * templateData = [self loadSubTemplateFile:subTemplateName];
            if (templateData != NULL) {
                [result replaceCharactersInRange:templateVarRange withString:templateData];
            }
        }
    }

    return result;
}

-(BOOL)loadIndexFile {
    // Load the file.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"html" inDirectory:@"Templates"];
    self.indexFile = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (indexFile == nil) {
        NSLog(@"Unable to read file: %@", filePath);
        return NO;
    }
    
    // Split the file.
    variableRange = [indexFile rangeOfString:JSON_DATA_VARIABLE];
    if (variableRange.location == NSNotFound) {
        foundRange = NO;
        NSLog(@"Unable to find template variable: %@", filePath);
    } else {
        foundRange = YES;
    }
    
    return YES;
}

-(NSString *)loadSubTemplateFile:(NSString *)subName {
    // Load the file.
    NSString *filePath = [[NSBundle mainBundle] pathForResource:subName ofType:@"json" inDirectory:@"Templates/json"];
    NSString * results = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    if (results == nil) {
        NSLog(@"Unable to read sub template file: %@", filePath);
        return NULL;
    }
    return results;
}

@end
