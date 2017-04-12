//
//  AlbumVideoViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "AlbumVideoViewController.h"
#import "playerViewController.h"
#import "TableViewCell.h"
#import "AlbumManager.h"
#import "VideoModel.h"
#import "Header.h"

#define CELL_ALBUM_ID @"CELL_ALBUM_ID"
//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface AlbumVideoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *deleteArr;

@end

@implementation AlbumVideoViewController

- (NSMutableArray *)dataSource {
    
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

- (NSMutableArray *)deleteArr {
    
    if (!_deleteArr) {
        _deleteArr = [[NSMutableArray alloc] init];
    }
    return _deleteArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"本地视频";
   
   
    [self layoutSetting];
    [self getAlbumVideoSource];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshUI) name:RefreshAlbumUINotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteSuccessRefreshUI) name:DeleteAlbumVideoSourceNotification object:nil];

}


- (void)clickLeftBarDelete {
    
    if ([AlbumManager shared].dataSource.count > 0) {
        [[AlbumManager shared] deleteAlbumVideo:self.deleteArr];
    }
}

- (void)deleteSuccessRefreshUI{
    
    [[AlbumManager shared].dataSource removeAllObjects];
    
    [self getAlbumVideoSource];
}



- (void)layoutSetting {
    
 
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64 - 49) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[TableViewCell class] forCellReuseIdentifier:CELL_ALBUM_ID];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 250, 50)];
    self.label.numberOfLines = 0;
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.center = self.view.center;
    self.label.textColor = [UIColor blackColor];
    [self.view addSubview:self.label];
    
}

- (void)getAlbumVideoSource {  //根据数据有无，判断控件的显示
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.dataSource removeAllObjects];
        [self.deleteArr removeAllObjects];
        [self.dataSource addObjectsFromArray:[AlbumManager shared].dataSource];
        
        for (VideoModel *model in self.dataSource) {
            [self.deleteArr addObject:model.videoAsset];
        }
        
        if ([[AlbumManager shared] getAlbumRight]) {
            if (self.dataSource.count > 0) {
                
                self.label.hidden = YES;
                self.tableView.hidden = NO;
                
            } else {
                self.tableView.hidden = YES;
                self.label.hidden = NO;
                self.label.text = @"相册没有视频";
            }
        } else {
            
            self.tableView.hidden = YES;
            self.label.hidden = NO;
            self.label.text = @"没有权限,请在设备的\"设置-隐私-照片\"中允许访问照片。";
            
            [self addAlbumVideoBtn];
        }
        [self.tableView reloadData];
    });
}

-(void)addAlbumVideoBtn{
    
    UIView *addVideosView = [[UIView alloc] initWithFrame:CGRectMake(10, 84, self.view.bounds.size.width - 20 , 80)];
    addVideosView.userInteractionEnabled = YES;
    addVideosView.layer.borderWidth = 1;
    addVideosView.layer.borderColor = [[UIColor grayColor] CGColor];
    [self.view addSubview:addVideosView];
    
    UITapGestureRecognizer* singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addVideosBtnClicked)];
    [addVideosView addGestureRecognizer:singleTap];
    
    UIImageView *addImageView = [[UIImageView alloc] initWithFrame:CGRectMake((addVideosView.frame.size.width -230)/2 ,25 , 30, 30)];
    addImageView.image = [UIImage imageNamed: @"AlbumAddBtn"];
    [addVideosView addSubview:addImageView];
    
    UILabel *addTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(addImageView.frame) + 10, 30, 200, 20)];
    addTextLabel.text = @"获取权限，添加本地视频";
    addTextLabel.font = [UIFont systemFontOfSize: 16];
    addTextLabel.textColor = [UIColor grayColor];
    [addVideosView addSubview:addTextLabel];
    
    
}

-(void)addVideosBtnClicked{
    
    UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"请获取权限" message:@"获取权限后，自动添加本地视频" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)refreshUI {
    [self getAlbumVideoSource];
}

#pragma mark 设置cell
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    return H(100);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_ALBUM_ID];
    VideoModel *videoModel = self.dataSource[indexPath.row];
    cell.model = videoModel;
    return cell;
}



#pragma mark 点击播放
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    PHAsset *asset = self.deleteArr[indexPath.row];
    
    [[PHImageManager defaultManager] requestPlayerItemForVideo:asset options:nil resultHandler:^(AVPlayerItem * _Nullable playerItem, NSDictionary * _Nullable info) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            playerViewController *MD = [[playerViewController alloc]init];
            MD.playerItem = playerItem;
            MD.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:MD animated:YES];
        });
    }];
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
