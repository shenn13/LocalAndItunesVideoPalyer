//
//  TabBarViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "TabBarViewController.h"
#import "FirstViewController.h"
#import "AlbumVideoViewController.h"
#import "iTunesViewController.h"


@interface TabBarViewController ()

@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [[UITabBar appearance] setBarTintColor:[UIColor colorWithRed:0.0/255 green:127.0/255 blue:207.0/255 alpha:1]];
    
    [self addSubViewsControllers0];
    [self customItem0];
    

    
}



#pragma mark 添加子视图控制

-(void)addSubViewsControllers0{
    NSArray *classTitles = @[@"AlbumVideoViewController",@"iTunesViewController"];
    NSMutableArray *mutArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0; i < classTitles.count; i++) {
        
        Class cts = NSClassFromString(classTitles[i]);
        
        UIViewController *vc = [[cts alloc] init];
        FirstViewController *naVC = [[FirstViewController alloc] initWithRootViewController:vc];
        [mutArr addObject:naVC];
    }
    self.viewControllers = mutArr;
    
    
}


#pragma mark 设置item
-(void)customItem0{
    
    NSArray *titles = @[@"本地视频",@"iTunes视频"];
    NSArray *normalImages = @[@"localvideos",@"itunes"];
    NSArray *selectImages = @[@"localvideos-select",@"itunes-select"];
    
    for (int i = 0; i < titles.count; i++) {
        
        UIViewController *vc = self.viewControllers[i];
        
        
        UIImage *normalImage = [UIImage imageWithOriginalImageName:normalImages[i]];
        UIImage *selectImage = [UIImage imageWithOriginalImageName:selectImages[i]];
        
        vc.tabBarItem = [[UITabBarItem alloc] initWithTitle:titles[i] image:normalImage selectedImage:selectImage];
       
        
    }
}

- (BOOL)shouldAutorotate
{
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        
        return [self.selectedViewController shouldAutorotate];
        
    }
    return NO; // tabbar第一栏旋转控制交给下级控制器，其他栏不支持自动旋转
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    if ([self.selectedViewController isEqual:[self.viewControllers objectAtIndex:0]]) {
        
        return [self.selectedViewController supportedInterfaceOrientations];
        
    }
    
    return UIInterfaceOrientationMaskPortrait; // tabbar第一栏控制器所支持旋转方向交给下级控制器处理，其他栏只支持竖屏方向
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
