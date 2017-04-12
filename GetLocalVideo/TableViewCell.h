//
//  TableViewCell.h
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;
@interface TableViewCell : UITableViewCell

@property(nonatomic, strong) VideoModel *model;

@end
