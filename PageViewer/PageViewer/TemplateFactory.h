//
//  TemplateFactory.h
//  PageViewer
//
//  Created by Dave on 2013-03-23.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Template.h"

@interface TemplateFactory : NSObject {
    NSMutableDictionary * dictionary;
}

-(id)init;
-(Template *)template:(NSString *)name;

@end
