//
//  FirstViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//
#import "FirstViewController.h"
#import <Photos/Photos.h>
#import "Header.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}


//- (BOOL)shouldAutorotate
//{
//    if ([self.topViewController isKindOfClass:[VideoPlayerViewController class]]) {
//        
//        return [self.topViewController shouldAutorotate];
//    }
//    return NO; // VideoViewController自动旋转交给改控制器自己控制，其他控制器则不支撑自动旋转
//}
//
//- (UIInterfaceOrientationMask)supportedInterfaceOrientations
//{
//    if ([self.topViewController isKindOfClass:[VideoPlayerViewController class]]) {
//        
//        return [self.topViewController supportedInterfaceOrientations];
//        
//    } else {
//        return UIInterfaceOrientationMaskPortrait; //VideoViewController所支持旋转交给改控制器自己处理，其他控制器则只支持竖屏
//    }
//}


@end
