//
//  TestTableViewController.m
//  DMPlayerView的简单的测试

//  Created by 高李军 on 16/7/7.
//  Copyright © 2016年 gaoleegin. All rights reserved.
//

#import "TestTableViewController.h"
#import "TestTableViewCell.h"
#import "XGVideo.h"

@interface TestTableViewController ()
{
    NSArray *_videos;
    
    NSArray *_assets;
}
@end

@implementation TestTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    NSMutableArray *assets = [NSMutableArray new];
    NSMutableArray *videos = [NSMutableArray new];
    for (int i = 0; i < 10; i++) {
        NSURL *videoUrl = [NSURL URLWithString:@"http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4"];
        AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoUrl];
        
        [assets addObject:urlAsset];
        
        XGVideo *video = [XGVideo new];
        video.urlAsString = @"http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4";
        [videos addObject:video];
    }
    
    _assets = assets;
    
    _videos = videos;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    TestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID"];
    
    if (cell == nil) {
        cell = [[TestTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    }
    
    cell.urlString = @"http://www.jxvdy.com/file/upload/201405/05/18-24-58-42-627.mp4";
    
    [cell.playView.player play];
//    [cell playAsset:_assets[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    TestTableViewCell *testcell = (TestTableViewCell *)cell;
    XGVideo *video = _videos[indexPath.row];
    video.currentTime = CMTimeGetSeconds(testcell.playView.player.currentTime);
    [testcell.playView.player pause];
    testcell.startBton.hidden = NO;
    NSLog(@"video current time: %f", video.currentTime);
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    TestTableViewCell *testcell = (TestTableViewCell *)cell;
    
    XGVideo *video = _videos[indexPath.row];

    if ([testcell.playerItem status] == AVPlayerItemStatusReadyToPlay ) {
        CMTime changedTime = CMTimeMakeWithSeconds(video.currentTime, 1);
        [testcell.playView.player seekToTime:changedTime completionHandler:^(BOOL finished) {
            [testcell.playView.player play];
            testcell.startBton.hidden = YES;
        }];
    }
    else {
        testcell.currentSecond = video.currentTime;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 300;
}


@end
