//
//  ArticleOverview.h
//  FeedReader
//
//  Created by Dave on 2013-08-05.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ArticleDetails.h"

@interface ArticleOverview : NSManagedObject

@property (nonatomic, retain) NSString * headline;
@property (nonatomic, retain) NSDate * pubDate;
@property (nonatomic, retain) NSString * uniqueId;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) ArticleDetails *details;

@end
