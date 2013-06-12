//
//  FeedLoaderDelegate.h
//
//  Created by Dave on 2013-06-12.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol FeedLoaderDelegate <NSObject>

/**
 Informs the delegate that loading is complete
 */
-(void)didLoadArticles:(NSMutableArray *) articleList sections:(NSMutableArray *)sectionList;

/**
 Notifies the delegate about progress
 */
-(void)didProgress:(NSString *)str;

@end
