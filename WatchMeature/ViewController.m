//
//  ViewController.m
//  WatchMeature
//
//  Created by Realank on 16/1/25.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>
#import <WatchConnectivity/WatchConnectivity.h>

@interface ViewController () <WCSessionDelegate>
@property (weak, nonatomic) IBOutlet UILabel *xLabel;
@property (weak, nonatomic) IBOutlet UILabel *yLabel;
@property (weak, nonatomic) IBOutlet UILabel *zLabel;

@property (nonatomic, strong) CMMotionManager *manager;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];

}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message replyHandler:(void (^)(NSDictionary<NSString *,id> * _Nonnull))replyHandler {
    replyHandler([[NSDictionary alloc]initWithObjectsAndKeys:@"success",@"received",nil]);
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%@",message);
        self.xLabel.text = message[@"x"];
        self.yLabel.text = message[@"y"];
        self.zLabel.text = message[@"z"];
    });
}
@end
