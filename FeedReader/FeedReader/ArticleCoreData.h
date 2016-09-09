//
//  ManagedObjectModel.h
//  FeedReader
//
//  Created by Dave on 2013-08-05.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "ArticleOverview.h"
#import "ArticleDetails.h"

@interface ArticleCoreData : NSObject {
    NSString * fileName;
    NSString * storeType;
}

@property (nonatomic, retain) NSString * fileName;
@property (nonatomic, retain) NSString * storeType;

- (id) initWithName:(NSString *)fileName;
- (BOOL) save:(NSError **)error;
- (void) deleteAllData;

- (ArticleOverview *) createArticleOverview;
- (ArticleOverview *) articleOverview:(NSString *)id;
- (void) deleteArticleOverview:(ArticleOverview *)overview;
- (NSArray *) articleOverviewData;

- (ArticleDetails *) createArticleDetails;

@end
