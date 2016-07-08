//
//  TestTableViewCell.h
//  DMPlayerView的简单的测试
//
//  Created by 高李军 on 16/7/7.
//  Copyright © 2016年 gaoleegin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerView.h"

@interface TestTableViewCell : UITableViewCell

@property (nonatomic,weak)PlayerView *playView;
@property (nonatomic,weak)UIButton *startBton;

- (void)playAsset:(AVURLAsset *)urlAsset;

@property (nonatomic,assign)CGFloat currentSecond;
@property (nonatomic,assign)CGFloat totalSecond;

@property (nonatomic ,strong) AVPlayerItem *playerItem;


@property (nonatomic,copy) NSString *urlString;


@end
