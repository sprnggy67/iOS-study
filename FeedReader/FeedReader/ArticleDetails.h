//
//  ArticleDetails.h
//  FeedReader
//
//  Created by Dave on 2013-08-05.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class ArticleOverview;

@interface ArticleDetails : NSManagedObject

@property (nonatomic, retain) NSString * templateName;
@property (nonatomic, retain) NSString * subTemplateName;
@property (nonatomic, retain) NSString * jsonData;
@property (nonatomic, retain) ArticleOverview *info;

@end
