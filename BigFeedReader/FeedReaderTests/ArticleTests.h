//
//  ArticleTests.h
//  FeedReader
//
//  Created by Dave on 2013-05-16.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "Article.h"

@interface ArticleTests : SenTestCase

+ (Article *) createArticle:(NSString *)headline template:(NSString *)template standFirst:(NSString *)sf body:(NSString *) body;

@end
