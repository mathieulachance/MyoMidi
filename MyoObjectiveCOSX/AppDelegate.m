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

MIDIWrapper *midi;
MIDIDeviceRef virtualDevice;
NSArray *command1;
NSArray *command2;

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
    midi = [[MIDIWrapper alloc] initWithClientName:@"Client" inPort:@"Input Port" outPort:@"Output Port"];
    NSLog(@"%@", [midi getDeviceList]);
    
    virtualDevice = [midi getDevice:@"IAC Driver"];
    
    [midi connectDevice: virtualDevice];
    
    command1 = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0x90], [NSNumber numberWithUnsignedInt:0x21], [NSNumber numberWithUnsignedInt:127],nil];
    
    command2 = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0x90], [NSNumber numberWithUnsignedInt:0x22], [NSNumber numberWithUnsignedInt:127],nil];
    
    
//    [midi sendData: command1 withDevice: virtualDevice];
    
    
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
    _roll_w = (roll + 1250)/2000.0 * 127;
    if(_roll_w < 0)
        _roll_w = 0;
    if(_roll_w > 127)
        _roll_w = 127;
    
    _pitch_w = (pitch + 2000)/2000.0 * 127;
    if(_pitch_w < 0)
        _pitch_w = 0;
    if(_pitch_w > 127)
        _pitch_w = 127;
    
    _yaw_w = (yaw + 2000)/2000.0 *127;
    if(_yaw_w < 0)
        _yaw_w = 0;
    else if(_yaw_w > 127)
        _yaw_w = 127;
    
    NSLog(@"Myo on orientation data, pull : %d, pitch : %d, yaw : %d", _roll_w, _pitch_w, _yaw_w);
    NSArray *rolling = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0xE0 ], [NSNumber numberWithUnsignedInt:0x0C], [NSNumber numberWithUnsignedInt:_roll_w],nil];
    
    [midi sendData:rolling withDevice:virtualDevice];
}
-(void)myo:(Myo *)myo onRssi:(int8_t)rssi
{
    NSLog(@"Myo on rssi");
}
-(void)myo:(Myo *)myo onPose:(MyoPose *)pose
{
    _poseType = pose.poseType;
    
    NSLog(@"posed : %u",_poseType);
    switch (_poseType) {
        case 3:
            NSLog(@"Im int");
            [midi sendData: command1 withDevice: virtualDevice];
            break;
        case 4:
           [midi sendData: command2 withDevice: virtualDevice];
        default:
            break;
    }
}

@end
