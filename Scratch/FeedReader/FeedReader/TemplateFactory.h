//
//  TemplateFactory.h
//
//  Creates and manages the set of templates in use.
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Template.h"

@interface TemplateFactory : NSObject

-(id)init;

/*
 Returns a template with the given name, or nil if it cannot be found.
 */
-(Template *)template:(NSString *)name;

@end
