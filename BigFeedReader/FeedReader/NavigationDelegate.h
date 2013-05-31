//
//  NavigationDelegate.h
//  FeedReader
//
//  Created by Dave on 2013-05-31.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NavigationDelegate <NSObject>

/*
 Asks the receiver to navigate to a specific article.
 */
- (void)navigateTo:(NSString *)destId;

@end
