//
//  NewsDataFactory.h
//  ReadJSON
//
//  Created by Dave on 2013-03-03.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsDataFactory : NSObject

-(void)test;
-(NSArray *)parseString:(NSString*)str;
-(NSArray *)parseResource:(NSString*)name;

@end
