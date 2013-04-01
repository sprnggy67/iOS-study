//
//  Downloader.h
//  FeedReader
//
//  Created by Dave on 2013-04-01.
//  Copyright (c) 2013 Dave. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Downloader : NSObject {
    NSMutableData * receivedData;
}

@property (strong, readonly, nonatomic) NSMutableData * receivedData;

-(id)init;
-(NSMutableData *)readFrom:(NSURL *)url error:(NSError **)error;

@end
