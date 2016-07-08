//
//  TestTableViewCell.m
//  DMPlayerView的简单的测试
//
//  Created by 高李军 on 16/7/7.
//  Copyright © 2016年 gaoleegin. All rights reserved.
//

#import "TestTableViewCell.h"
#import "PlayerView.h"

@interface TestTableViewCell ()

@property (nonatomic ,strong) AVPlayer *player;



//@property (nonatomic ,strong) AVPlayerItem *playerItem;
@property (nonatomic ,strong) id playbackTimeObserver;

@property (nonatomic,assign) BOOL isPasue;


@property (weak, nonatomic) AVURLAsset *urlAsset;

@end

@implementation TestTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self creatSubViews];
    }
    return self;
}

- (void)dealloc {
//    [self.playView.player removeTimeObserver:self.playbackTimeObserver];
    [self.playerItem removeObserver:self forKeyPath:@"status"];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
}

-(void)layoutSubviews {
    [super layoutSubviews];
//    self.playView.frame = self.contentView.bounds;
    
    CGFloat playViewX = 10;
    CGFloat playViewY = 10;
    CGFloat playViewW = [UIScreen mainScreen].bounds.size.width - 2 * playViewX;
    CGFloat playViewH = 200;
    
    self.playView.frame = CGRectMake(playViewX, playViewY, playViewW, playViewH);
    
    
    self.startBton.frame = CGRectMake(20, 20, 50, 50);
    self.startBton.center = CGPointMake(playViewW * 0.5, playViewH * 0.5);
    
}

-(void)creatSubViews{
    PlayerView *playView = [[PlayerView alloc]init];
    playView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:playView];
    self.playView = playView;
    
    UIButton *startBton = [UIButton  buttonWithType:UIButtonTypeCustom];
    startBton.backgroundColor = [UIColor yellowColor];
    [self.playView addSubview:startBton];
    self.startBton = startBton;
    
}

- (void)setUrlString:(NSString *)urlString{
    _urlString = urlString;
    
    [self.playerItem removeObserver:self forKeyPath:@"status"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemFailedToPlayToEndTimeNotification object:self.playerItem];
    
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:_urlString]];
    
    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    // 添加视频播放结束通知(NSNotification *)notification {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayDidEnd:) name:AVPlayerItemFailedToPlayToEndTimeNotification object:_playerItem];
    
    
    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
    
    self.playView.player = _player;
    
}

- (void)moviePlayDidEnd:(NSNotification *)notification {
    
    NSLog(@"哈哈哈");
    
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
            //            [self monitoringPlayback:self.playerItem];// 监听播放状态
            [self.playView.player seekToTime:CMTimeMakeWithSeconds(self.currentSecond, 1) completionHandler:^(BOOL finished) {
                [self.playView.player play];
                self.startBton.hidden = YES;
                
            }];
            
        } else if ([playerItem status] == AVPlayerStatusFailed) {
            NSLog(@"AVPlayerStatusFailed");
        }
    }
}


//- (void)playAsset:(AVURLAsset *)urlAsset {
//    self.urlAsset = urlAsset;
//    self.playerItem = [AVPlayerItem playerItemWithAsset:self.urlAsset];
////    [self.playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];// 监听status属性
//    self.player = [AVPlayer playerWithPlayerItem:self.playerItem];
//    self.playView.player = _player;
//
//    [self.urlAsset loadValuesAsynchronouslyForKeys:@[ @"duration" ] completionHandler:^{
//        NSError *error;
//        AVKeyValueStatus status = [self.urlAsset statusOfValueForKey:@"duration" error:&error];
//        if (error) {
//            NSLog(@"%@", error.localizedDescription);
//            return;
//        }
//
//        if (status == AVKeyValueStatusLoaded) {
//            [self.playView.player play];
//            self.totalSecond = self.urlAsset.duration.value / self.urlAsset.duration.timescale;
//        }
//    }];
//}


//- (void)monitoringPlayback:(AVPlayerItem *)playerItem {
//    __weak typeof(self) weakSelf = self;
//    self.playbackTimeObserver = [self.playView.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
//        self.currentSecond = playerItem.currentTime.value/playerItem.currentTime.timescale;// 计算当前在第几秒
//    }];
//}



@end
