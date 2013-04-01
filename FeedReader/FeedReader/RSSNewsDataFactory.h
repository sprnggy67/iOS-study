//
//  RSSNewsDataFactory.h
//  FeedReader
//
//  Created by Dave on 2013-03-27.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Article.h"

@interface RSSNewsDataFactory : NSObject <NSXMLParserDelegate> {
    NSMutableArray * results;
    NSMutableDictionary * currentArticleAttributes;
    NSString * currentStringValue;
    BOOL inItem;
}

-(void)test;
-(NSArray *)parseString:(NSString*)str;
-(NSArray *)parseResource:(NSString*)name;
-(NSArray *)parseData:(NSData*)data;

@property (strong, nonatomic) NSMutableDictionary * currentArticleAttributes;
@property (strong, nonatomic) NSString * currentStringValue;

@end
