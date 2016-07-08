//
//  ViewController.m
//  DMPlayerView的简单的测试
//
//  Created by 高李军 on 16/7/7.
//  Copyright © 2016年 gaoleegin. All rights reserved.
//

#import "ViewController.h"
#import "PlayerView.h"

#import "TestTableViewController.h"

@interface ViewController ()

@property (nonatomic ,strong) AVPlayer *player;
@property (nonatomic,weak)PlayerView *playView;
@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) id playbackTimeObserver;

@property (nonatomic,assign) BOOL isPasue;

@property (nonatomic,assign)CGFloat currentSecond;
@property (nonatomic,assign)CGFloat totalSecond;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    PlayerView *playView = [[PlayerView alloc]init];
    playView.backgroundColor = [UIColor redColor];
    playView.frame = CGRectMake(100, 200, 200, 200);
    [self.view addSubview:playView];
    self.playView = playView;
    
    NSURL *videoUrl = [NSURL URLWithString:@"http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4"];
    self.playerItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    self.playView.player = _player;
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor redColor];
    btn.frame = CGRectMake(20, 120, 50, 50);
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
}

- (void)btnClicked{
    
    
    TestTableViewController *testVC = [[TestTableViewController alloc]init];
    [self.navigationController pushViewController:testVC animated:YES];
    
    return;
    CMTime changedTime = CMTimeMakeWithSeconds(self.currentSecond, 1);
    __weak typeof(self) weakSelf = self;
    //快进
    [self.playView.player seekToTime:changedTime completionHandler:^(BOOL finished) {
        [weakSelf.playView.player play];
    }];
}



-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.playView.player play];
    self.isPasue = NO;
}


// KVO方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            NSLog(@"AVPlayerStatusReadyToPlay");
            CMTime duration = self.playerItem.duration;// 获取视频总长度
            self.totalSecond = playerItem.duration.value / playerItem.duration.timescale;// 转换成秒
            NSLog(@"==========转换成秒%f",self.totalSecond);
            NSLog(@"movie total duration:%f",CMTimeGetSeconds(duration));
            
            CGFloat currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
            NSLog(@"=====status当前在第几秒===转换成秒%f",currentSecond);
            [self monitoringPlayback:self.playerItem];// 监听播放状态
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    }
}

- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
    __weak typeof(self) weakSelf = self;
    self.playbackTimeObserver = [self.playView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        self.currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isPasue = !self.isPasue;
    if (self.isPasue) {
        [self.playView.player pause];
    } else {
        [self.playView.player play];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
