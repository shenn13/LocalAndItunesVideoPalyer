//
//  AppDelegate.m
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <Photos/Photos.h>
#import "AlbumManager.h"
#import "FileWatcher.h"
#import "AppDelegate.h"
#import "TabBarViewController.h"


@interface AppDelegate (){
    
    NSMutableArray *_dataUrlStr;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[FileWatcher shared] startManager];
    
    [self getAlbumRightAndSource]; //获取相册权限和数据
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    
    TabBarViewController *tabBarVC = [[TabBarViewController alloc] init];
    
    self.window.rootViewController = tabBarVC;
        
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)getAlbumRightAndSource{
    
    PHAuthorizationStatus author = [PHPhotoLibrary authorizationStatus];
    
    if (author == PHAuthorizationStatusNotDetermined || author == PHAuthorizationStatusRestricted || author == PHAuthorizationStatusDenied) {
        
        NSLog(@" 用户尚未做出选择这个应用程序的问候||此应用程序没有被授权访问的照片数据 || 用户已经明确否认了这一照片数据的应用程序访问");
        
    }else{
        [[AlbumManager shared] startManager];
        return;
    }
    if ([PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) {
                
                [[AlbumManager shared] startManager];
                
                NSLog(@"相册授权开启，启动AlbumManager");
            }
        }];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [[FileWatcher shared] stopManager];
    [[AlbumManager shared] stopManager];
}



- (void)applicationWillResignActive:(UIApplication *)application {
    
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    

    
    
    
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
    
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}




@end
