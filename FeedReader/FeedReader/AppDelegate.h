//
//  AppDelegate.h
//  PageViewer
//
//  Created by Dave on 2013-03-02.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ArticleCoreData.h"

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate> {

    ArticleCoreData * managedObjectModel;

}

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain, readonly) ArticleCoreData *articleData;

@end
