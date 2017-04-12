//
//  FileWatcher.h
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.//

#import <Foundation/Foundation.h>
#import "Header.h"
@interface FileWatcher : NSObject

singleton_interface(FileWatcher)

@property (nonatomic, assign) BOOL isFinishedCopy;

@property (nonatomic, strong) NSMutableArray *dataSource;

- (void)startManager;
- (void)stopManager;
- (void)deleteiTunesVideo:(NSArray *)array;

@end
