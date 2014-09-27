//
//  AppDelegate.m
//  MyoObjectiveCOSX
//
//  Created by Remi Santos on 05/08/2014.
//  Copyright (c) 2014 Remi Santos. All rights reserved.
//

#import "AppDelegate.h"
#import "MyoObjectiveC.h"
#import "MIDIWrapper.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    
    Myo *newMyo = [[Myo alloc] initWithApplicationIdentifier:@"com.example.myoobjc"];
    
    BOOL found = false;
    while (!found) {
        found = [newMyo connectMyoWaiting:10000];
    }
    newMyo.delegate = self;
    newMyo.updateTime = 1000;
    [newMyo startUpdate];
    
    
    // Insert code here to initialize your application
    MIDIWrapper *midi = [[MIDIWrapper alloc] initWithClientName:@"Client" inPort:@"Input Port" outPort:@"Output Port"];
    NSLog(@"%@", [midi getDeviceList]);
    
    MIDIDeviceRef virtualDevice = [midi getDevice:@"IAC Driver"];
    
    [midi connectDevice: virtualDevice];
    
    NSArray *command1 = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0x90], [NSNumber numberWithUnsignedInt:0x21], [NSNumber numberWithUnsignedInt:127],nil];
    
    NSArray *command2 = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0x80], [NSNumber numberWithUnsignedInt:0x21], [NSNumber numberWithUnsignedInt:127],nil];
    
    
    [midi sendData: command1 withDevice: virtualDevice];
    
    
}
-(void)myoOnConnect:(Myo *)myo
{
    NSLog(@"Myo on connect");
}
-(void)myoOnDisconnect:(Myo *)myo
{
    NSLog(@"Myo on disconnect");
}
-(void)myoOnArmRecognized:(Myo *)myo
{
    NSLog(@"Myo on arm recognized");
}
-(void)myoOnArmLost:(Myo *)myo
{
    NSLog(@"Myo on arm lost");
}
-(void)myoOnPair:(Myo *)myo
{
    NSLog(@"Myo on pair");
}

-(void)myo:(Myo *)myo onAccelerometerDataWithVector:(MyoVector*)vector
{
    NSLog(@"Myo on accelerometer data");
}
-(void)myo:(Myo *)myo onGyroscopeDataWithVector:(MyoVector*)vector
{
    NSLog(@"Myo on gyroscope data");
}
-(void)myo:(Myo *)myo onOrientationDataWithRoll:(int)roll pitch:(int)pitch yaw:(int)yaw
{
    _roll_w = roll;
    _pitch_w = pitch;
    _yaw_w = yaw;
    //NSLog(@"Myo on orientation data, pull : %d", roll);
    
}
-(void)myo:(Myo *)myo onRssi:(int8_t)rssi
{
    NSLog(@"Myo on rssi");
}
-(void)myo:(Myo *)myo onPose:(MyoPose *)pose
{
    _poseType = pose.poseType;
    
    NSLog(@"posed : %u",_poseType);
}

@end
