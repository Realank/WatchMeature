//
//  InterfaceController.m
//  WatchMeature WatchKit Extension
//
//  Created by Realank on 16/1/25.
//  Copyright © 2016年 realank. All rights reserved.
//

#import "InterfaceController.h"
#import <CoreMotion/CoreMotion.h>
#import <WatchConnectivity/WatchConnectivity.h>
#import <HealthKit/HealthKit.h>


@interface InterfaceController()<WCSessionDelegate,HKWorkoutSessionDelegate>

@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *xLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *yLabel;
@property (unsafe_unretained, nonatomic) IBOutlet WKInterfaceLabel *zLabel;

@property (nonatomic, strong) CMMotionManager *manager;
@property (nonatomic, strong) HKHealthStore *healthStore;
@end

@implementation InterfaceController

- (void)awakeWithContext:(id)context {
    [super awakeWithContext:context];
    
    HKWorkoutSession *session = [[HKWorkoutSession alloc]initWithActivityType:HKWorkoutActivityTypeRunning  locationType:HKWorkoutSessionLocationTypeOutdoor];
    session.delegate = self;
    [self.healthStore startWorkoutSession:session];
    
    
}

- (void)willActivate {
    // This method is called when watch view controller is about to be visible to user
    [super willActivate];
    
    WCSession* session = [WCSession defaultSession];
    session.delegate = self;
    [session activateSession];
    
    
    
    _manager = [[CMMotionManager alloc] init];
    if (_manager.accelerometerAvailable) {
        NSLog(@"accelerometerAvailable");
        _manager.accelerometerUpdateInterval = 0.1;
        __block BOOL sendSuccess = YES;
        [_manager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            CMAcceleration acc = accelerometerData.acceleration;
            //NSLog(@"%f,%f,%f",acc.x,acc.y,acc.x);
            NSString* x = [NSString stringWithFormat:@"x:%lf",acc.x];
            NSString* y = [NSString stringWithFormat:@"y:%lf",acc.y];
            NSString* z = [NSString stringWithFormat:@"z:%lf",acc.z];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                
                [self.xLabel setText:x];
                [self.yLabel setText:y];
                [self.zLabel setText:z];
                if (sendSuccess) {
                    sendSuccess = NO;
                    NSDictionary *dict = [NSDictionary dictionaryWithObjects:@[x,y,z] forKeys:@[@"x",@"y",@"z"]];
                    [session sendMessage:dict replyHandler:^(NSDictionary<NSString *,id> * _Nonnull replyMessage) {
                        sendSuccess = YES;
                    } errorHandler:^(NSError * _Nonnull error) {
                        
                    }];
                }
                
            });
            
        }];
    }
    


}

- (void)didDeactivate {
    // This method is called when watch view controller is no longer visible
    [super didDeactivate];
}

- (void)session:(WCSession *)session didReceiveMessage:(NSDictionary<NSString *,id> *)message {
    
}

- (void)workoutSession:(HKWorkoutSession *)workoutSession didFailWithError:(NSError *)error {
    
}


@end



