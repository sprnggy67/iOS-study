//
//  FeedStore.m
//  FeedReader
//
//  Created by Dave on 2013-04-04.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import "FeedStore.h"

@interface FeedStore ()

@property (strong, nonatomic) NSString * pListFileName;
@property (strong, nonatomic) NSMutableArray * feeds;

-(id)init;
-(void)read;
-(void)write;

@end

@implementation FeedStore

@synthesize pListFileName;
@synthesize feeds;

static FeedStore * singleton;

#pragma mark - Init

+ (FeedStore *) singleton {
    if (singleton == nil) {
        singleton = [[FeedStore alloc] init];
        [singleton read];
    }
    return singleton;
}

-(id)init {
    self = [super init];
    if (self != nil) {
        NSArray *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentFolder = [documentPath objectAtIndex:0];
        self.pListFileName = [documentFolder stringByAppendingPathComponent:@"FeedStore.plist"];
        self.feeds = [[NSMutableArray alloc] init];
    }
    return self;
}

#pragma mark - Getters / Setters

- (NSArray *)feeds {
    return feeds;
}

- (int)count {
    return [feeds count];
}

-(BOOL)isEmpty {
    return ([feeds count] == 0);
}

- (void) add:(Feed *)feed {
    if (![feeds containsObject:feed]) {
        [feeds addObject:feed];
        [self write];
    }
}

- (void) remove:(Feed *)feed {
    if ([feeds containsObject:feed]) {
        [feeds removeObject:feed];
        [self write];
    }
}

-(void)read {
    self.feeds = [[NSMutableArray alloc] init];
    
    NSArray * pListArray = [NSArray arrayWithContentsOfFile:pListFileName];
    if (pListArray == nil) {
        NSLog(@"Unable to read pList from FeedStore file");
        return;
    }

    for (NSDictionary * dictionary in pListArray) {
        Feed * feed = [Feed feedFromDictionary:dictionary];
        if (feed == nil) {
            NSLog(@"Unable to read feed from dictionary");
        } else {
            [feeds addObject:feed];
        }
    }
}

-(void)write {
    NSMutableArray * pListArray = [[NSMutableArray alloc] init];
    for (Feed * feed in self.feeds) {
        NSDictionary * pListItem = [feed toDictionary];
        [pListArray addObject:pListItem];
    }

    BOOL ok = [pListArray writeToFile:pListFileName atomically:TRUE];
    if (!ok) {
        NSLog(@"Unable to save pList in FeedStore file");
    }
}

@end
