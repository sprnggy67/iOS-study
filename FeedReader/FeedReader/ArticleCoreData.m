//
//  ManagedObjectModel.m
//  FeedReader
//
//  Created by Dave on 2013-08-05.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "ArticleCoreData.h"
#import "ArticleOverview.h"
#import "ArticleDetails.h"

@interface ArticleCoreData () {
    
    NSManagedObjectModel * managedObjectModel;
    NSManagedObjectContext * managedObjectContext;
    NSPersistentStoreCoordinator * persistentStoreCoordinator;
    
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@end

@implementation ArticleCoreData

@synthesize fileName;
@synthesize storeType;

- (id) initWithName:(NSString *)fileNameParam {
    self = [super init];
    if (self) {
        self.fileName = fileNameParam;
        self.storeType = NSSQLiteStoreType;
     }
    return self;
}

- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: self.fileName]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    NSPersistentStore * persistentStore = [persistentStoreCoordinator addPersistentStoreWithType:self.storeType
                                                               configuration:nil
                                                                         URL:storeUrl
                                                                     options:nil
                                                                       error:&error];
    if(!persistentStore) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    
    return managedObjectModel;
}

- (BOOL)save:(NSError **)error {
    BOOL result = [[self managedObjectContext] save:error];
    if (!result) {
        NSLog(@"Whoops, couldn't save: %@", [*error localizedDescription]);
    }
    return result;
}

- (void)deleteAllData {
    NSArray * data = [self articleOverviewData];
    for (int x = 0; x < [data count]; x++ ) {
        ArticleOverview * overview = [data objectAtIndex:x];
        [self deleteArticleOverview:overview];
    }
}

- (ArticleOverview *) createArticleOverview {
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"ArticleOverview"
            inManagedObjectContext:[self managedObjectContext]];
}

- (ArticleOverview *) articleOverview:(NSString *)id {
    // Create the fetch request.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Set the entity.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ArticleOverview"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Set the predicate.
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(uniqueId LIKE[c] %@)", id];
    [fetchRequest setPredicate:predicate];
    
    // Execute the request.
    NSError * error;
    NSArray * fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    // Return the first item.
    if ([fetchedObjects count] == 0)
        return nil;
    else
        return [fetchedObjects objectAtIndex:0];
}

- (void) deleteArticleOverview:(ArticleOverview *) overview {
    [[self managedObjectContext] deleteObject:overview];
}

- (NSArray *) articleOverviewData {
    // Create the fetch request
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    // Set the entity
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ArticleOverview"
                                              inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    // Execute the request.
    NSError * error;
    NSArray * fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (ArticleDetails *) createArticleDetails {
    return [NSEntityDescription
            insertNewObjectForEntityForName:@"ArticleDetails"
            inManagedObjectContext:[self managedObjectContext]];
}

@end
