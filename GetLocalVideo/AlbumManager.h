//
//  AlbumManager.h
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>
#import "Header.h"


typedef NS_ENUM(NSInteger, AlbumVideoBehaviorType) {
    
    /**
     *  获取相册全部视频
     */
    ALBUMVIDEOBEHAVIOR_GETALL = 0,
    
    /**
     *  相册添加视频
     */
    ALBUMVIDEOBEHAVIOR_INSTER = 1,
    
    /**
     *  相册删除视频
     */
    ALBUMVIDEOBEHAVIOR_REMOVE = 2
    
};



@interface AlbumManager : NSObject

singleton_interface(AlbumManager)

@property (nonatomic, strong) NSMutableArray *dataSource;

/**
 注册相册的监听
 */
- (void)startManager;

/**
  注销相册的监听
 */
- (void)stopManager;

/**
 *  获取相机的授权
 *  @return YES/NO
 */
- (BOOL)getCameraRight;

/**
 *  获取相册的授权
 *  @return YES/NO
 */
- (BOOL)getAlbumRight;

/**
 *  获取所需要的Video属性
 *
 *  @param type TFVideoAssetType
 *
 *  @return 资源数组
 */

- (void)getAlbumVideoWithBehaviorType:(AlbumVideoBehaviorType)type PHObjectsArr:(NSArray *)phobjectsArr;

//删除相册视频
- (void)deleteAlbumVideo:(NSArray *)assetArr;

@end
