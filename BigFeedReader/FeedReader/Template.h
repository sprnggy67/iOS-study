//
//  Template.h
//
//  An HTML5 template, used to define the presentation of an article.

//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Template : NSObject

@property (strong, nonatomic) NSString * name;
@property (strong, nonatomic) NSBundle * bundle;

/*
 Creates a new template with a name.
 The template itself will be loaded (eventually) from a file called name.html in the Supporting Files.
 */
-(id)initWith:(NSString *)name bundle:(NSBundle *) bundle;

/*
 Injects an article into a template and returns the final HTML
 */
-(NSString *)load:(NSString *)contents;

/*
 Injects an article and a subtemplate into a template and returns the final HTML
 */
-(NSString *)load:(NSString *)contents subTemplate:(NSString *)subTemplateName;

@end
