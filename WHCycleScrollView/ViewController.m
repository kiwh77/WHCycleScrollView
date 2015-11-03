//
//  ViewController.m
//  WHCycleScrollView
//
//  Created by 吴浩 on 15/11/3.
//  Copyright © 2015年 wuhao. All rights reserved.
//

#import "ViewController.h"
#import "WHCycleScrollView.h"

@interface ViewController ()
@property (nonatomic, strong) WHCycleScrollView * cycleScrollView;
@end

@implementation ViewController
@synthesize cycleScrollView;
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSMutableArray * urls = [NSMutableArray array];
    NSArray * webImages = @[@"http://pic.3gbizhi.com/2015/1006/20151006032522782.jpg.640.1136.jpg",
                      @"http://pic.3gbizhi.com/2015/0929/20150929013750986.jpg.640.1136.jpg",
                      @"http://pic.3gbizhi.com/2015/0929/20150929013752275.jpg.640.1136.jpg",
                      @"http://pic.3gbizhi.com/2015/0929/20150929013750810.jpg.640.1136.jpg",
                      @"http://pic.3gbizhi.com/2015/0910/20150910030842525.jpg.640.1136.jpg",
                      @"http://pic.3gbizhi.com/2015/0910/20150910030843682.jpg.640.1136.jpg"];
    [webImages enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [urls addObject:[NSURL URLWithString:obj]];
    }];
    [urls addObjectsFromArray:@[@"0.jpg",@"1.jpg",@"2.jpg"]];
    
//    WHCycleScrollView * cycleScrollView = [[WHCycleScrollView alloc] initWithFrame:self.view.bounds];
    cycleScrollView = [WHCycleScrollView cycleScrollViewWithFrame:self.view.bounds dataSource:urls pageControl:YES autoCycle:YES];
    cycleScrollView.autoCycleInterval = 2.0f;
    
    [cycleScrollView setTapAction:^(NSInteger index) {
        NSLog(@"tap action : %zi",index);
    }];
    
    [cycleScrollView setLongPressAction:^(NSInteger index) {
        NSLog(@"long press : %zi",index);
    }];
    
    [self.view addSubview:cycleScrollView];
    
    [self performSelector:@selector(changeDataSource) withObject:nil afterDelay:10.0f];
}

-(void)changeDataSource
{
    cycleScrollView.dataSource = @[@"0.jpg",@"1.jpg",@"2.jpg"];
}



@end
