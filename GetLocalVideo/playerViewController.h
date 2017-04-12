//
//  playerViewController.h
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "BaseViewController.h"
@interface playerViewController : BaseViewController

@property (nonatomic , strong) AVPlayerItem* playerItem;
@end
