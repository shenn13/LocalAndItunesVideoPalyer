//
//  VideoModel.h
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
@interface VideoModel : NSObject

@property (nonatomic, copy) NSString *videoName;

@property (nonatomic, copy) NSString *videoPath;

@property (nonatomic, copy) NSString *videoImgPath;

@property (nonatomic, assign) long long videoSize;

@property (nonatomic, strong) PHAsset *videoAsset;

@end
