//
//  AppDelegate.h
//  MyoObjectiveCOSX
//
//  Created by Remi Santos on 05/08/2014.
//  Copyright (c) 2014 Remi Santos. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MyoObjectiveC.h"
@interface AppDelegate : NSObject <NSApplicationDelegate, MyoDelegate>

@property (assign) IBOutlet NSWindow *window;

@property (nonatomic, assign)int roll_w;
@property (nonatomic, assign)int pitch_w;
@property (nonatomic, assign)int yaw_w;
@property (nonatomic, assign)int last_yaw;
@property (nonatomic, assign)int yaw_withDiff;
@property (nonatomic, assign)int yaw_myo;

@property (nonatomic)MyoPoseType poseType;

@property (nonatomic)int mode;

@end
