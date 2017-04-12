//
//  playerViewController.m
//  GetLocalVideo
//
//  Created by shen on 17/1/14.
//  Copyright © 2017年 shen. All rights reserved.
//

#import "playerViewController.h"
#import "Slider.h"
#import "UIImage+TintColor.h"
#import "UIImage+ScaleToSize.h"
#import "UIView+SetRect.h"

//屏幕的宽和高
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//进度条颜色
#define ProgressColor     [UIColor colorWithRed:1.00000f green:1.00000f blue:1.00000f alpha:0.40000f]
//缓冲颜色
#define ProgressTintColor [UIColor colorWithRed:1.00000f green:1.00000f blue:1.00000f alpha:1.00000f]
//播放完成颜色
#define PlayFinishColor   [UIColor redColor]
//滑块颜色
#define SliderColor       [UIColor redColor]

@interface playerViewController ()

@property (nonatomic,strong)AVPlayer *player;
/**播放按钮*/
@property (nonatomic,strong) UIButton *startButton;
/**缓冲进度条*/
@property(nonatomic,strong)UIProgressView *progress;
/**播放时间*/
@property(nonatomic,strong)UILabel *currentTimeLabel;
/**播放进度条*/
@property(nonatomic,strong)Slider *slider;
/**底部视图*/
@property(nonatomic,strong)UIView *buttomView;

@end

@implementation playerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    
    [self customNavigationItem];
    
    [self createVideosView];
    
    [self createButtomView];
    
}

//自定视图控制器的navigationItem
-(void)customNavigationItem{

    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 10, 27, 27)];
    [backBtn setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem  * backItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem =  backItem;
    
}
-(void)backBtnClick{
    
    [_player pause];
    [_player cancelPendingPrerolls];
    [_player.currentItem.asset cancelLoading];
    _player = nil;

    [self.navigationController popViewControllerAnimated:NO];
    
}

-(void)createVideosView{
    
    self.player = [[AVPlayer alloc]initWithPlayerItem:_playerItem];
    
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //设置模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerLayer.contentsScale = [UIScreen mainScreen].scale;
    playerLayer.frame = CGRectMake(0, 84, kScreenWidth, kScreenHeight *0.6 - 84);
    [self.view.layer addSublayer:playerLayer];
    
    [self.player play];
    
    // 监听loadedTimeRanges属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
    //计时器，循环执行
    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(timeStack) userInfo:nil repeats:YES];
    
    //AVPlayer播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
}


-(void)createButtomView{
    self.buttomView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight * 0.6, kScreenWidth, kScreenHeight *0.4)];
    [self.view addSubview:self.buttomView];
    
    //添加进度条
    [self createProgress];
    //添加进度条
    [self createSlider];
    //添加时间
    [self createCurrentTimeLabel];
    //  添加开始暂停按钮
    [self createStartButton];
    
}

#pragma mark - 创建UIProgressView
- (void)createProgress{
    
    self.progress = [[UIProgressView alloc]initWithFrame:CGRectMake(20, 30 ,kScreenWidth - 160, 20)];
    //进度条颜色
    self.progress.trackTintColor = ProgressColor;
    // 计算缓冲进度
    NSTimeInterval timeInterval = [self availableDuration];
    
    CMTime duration = self.playerItem.duration;
    
    CGFloat totalDuration = CMTimeGetSeconds(duration);
    
    [self.progress setProgress:timeInterval / totalDuration animated:NO];
    
    CGFloat time = round(timeInterval);
    CGFloat total = round(totalDuration);
    
    //确保都是number
    if (isnan(time) == 0 && isnan(total) == 0){
        if (time == total){
            //缓冲进度颜色
            self.progress.progressTintColor = ProgressTintColor;
        }else{
            //缓冲进度颜色
            self.progress.progressTintColor = ProgressTintColor;
        }
    }else{
        //缓冲进度颜色
        self.progress.progressTintColor = ProgressTintColor;
    }
    [self.buttomView addSubview:_progress];
}

#pragma mark - 创建UISlider
- (void)createSlider{
    
    self.slider = [[Slider alloc] initWithFrame:CGRectMake(_progress.x, 20 ,_progress.width, 20)];
    //自定义滑块大小
    UIImage *image = [UIImage imageNamed:@"tools-time2"];
    //改变滑块大小
    UIImage *tempImage = [image OriginImage:image scaleToSize:CGSizeMake(20, 20)];
    //改变滑块颜色
    UIImage *newImage = [tempImage imageWithTintColor:SliderColor];
    
    [_slider setThumbImage:newImage forState:UIControlStateNormal];
    //添加监听
    [_slider addTarget:self action:@selector(progressSlider:) forControlEvents:UIControlEventValueChanged];
    //左边颜色
    _slider.minimumTrackTintColor = PlayFinishColor;
    //右边颜色
    _slider.maximumTrackTintColor = [UIColor clearColor];
    
    [self.buttomView addSubview:self.slider];
}
#pragma mark - 创建播放时间
- (void)createCurrentTimeLabel{
    
    self.currentTimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 140, 20, 120, 20)];
    _currentTimeLabel.textColor = [UIColor whiteColor];
    _currentTimeLabel.font = [UIFont systemFontOfSize:14];
    _currentTimeLabel.textAlignment = NSTextAlignmentCenter;
    
    _currentTimeLabel.text = @"00:00/00:00";
    
    [self.buttomView addSubview:_currentTimeLabel];
    
}

#pragma mark - 播放按钮
- (void)createStartButton{
    
    _startButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth - 80)/2,self.buttomView.height/3 , 80, 80)];
    _startButton.adjustsImageWhenHighlighted = NO;
    [_startButton setImage:[UIImage imageNamed:@"localpause.png"] forState:UIControlStateNormal];
    [_startButton setImage:[UIImage imageNamed:@"localplay.png"] forState:UIControlStateSelected];
    [_startButton addTarget:self action:@selector(startAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.buttomView addSubview:_startButton];
    
}

#pragma mark - 拖动进度条
- (void)progressSlider:(UISlider *)slider{
    //拖动改变视频播放进度
    if (_player.status == AVPlayerStatusReadyToPlay){
        //暂停
        [_player pause];
        
        //计算出拖动的当前秒数
        CGFloat total = (CGFloat)_playerItem.duration.value / _playerItem.duration.timescale;
        NSInteger dragedSeconds = floorf(total * slider.value);
        
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [_player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            //继续播放
            [_player play];
        }];
        
    }
}


#pragma mark - 计时器事件
- (void)timeStack{
    if (_playerItem.duration.timescale != 0){
        _slider.maximumValue = 1;//总共时长
        _slider.value = CMTimeGetSeconds([_playerItem currentTime]) / (_playerItem.duration.value / _playerItem.duration.timescale);//当前进度
        //当前时长进度progress
        NSInteger proMin = (NSInteger)CMTimeGetSeconds([_player currentTime]) / 60;//当前秒
        NSInteger proSec = (NSInteger)CMTimeGetSeconds([_player currentTime]) % 60;//当前分钟
        //duration 总时长
        NSInteger durMin = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale / 60;//总秒
        NSInteger durSec = (NSInteger)_playerItem.duration.value / _playerItem.duration.timescale % 60;//总分钟
        self.currentTimeLabel.text = [NSString stringWithFormat:@"%02ld:%02ld / %02ld:%02ld", (long)proMin, (long)proSec, (long)durMin, (long)durSec];
        
    }
 
}

#pragma mark - 缓存条监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        // 计算缓冲进度
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.playerItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.progress setProgress:timeInterval / totalDuration animated:NO];
        //设置缓存进度颜色
        self.progress.progressTintColor = [UIColor grayColor];
    }
}
//计算缓冲进度
- (NSTimeInterval)availableDuration{
    NSArray *loadedTimeRanges = [[_player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}



#pragma mark - 播放暂停按钮方法
- (void)startAction:(UIButton *)button{
    if (button.selected == NO){
        [_player pause];
    }else{
        [_player play];
    }
    button.selected =!button.selected;
}
#pragma mark - 播放完成
- (void)moviePlayDidEnd:(id)sender{
    
    [_player pause];

}

#pragma mark - dealloc
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:_player.currentItem];
    
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    NSLog(@"释放内存啦");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
