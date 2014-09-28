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

NSArray *rolling;

NSInteger *mode = 0;

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
    newMyo.updateTime = 10000;
    [newMyo startUpdate];
    
    
    // Insert code here to initialize your application
    midi = [[MIDIWrapper alloc] initWithClientName:@"Client" inPort:@"Input Port" outPort:@"Output Port"];
    NSLog(@"%@", [midi getDeviceList]);
    
    virtualDevice = [midi getDevice:@"IAC Driver"];
    
    [midi connectDevice: virtualDevice];
  
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
    _roll_w = (roll+2000)/3000.0 * 127;
    _pitch_w = pitch;
    _yaw_w = 127 - 1.25 *(yaw+2000) / 3000.0 * 127;
    if(_yaw_w > 127)
        _yaw_w = 127;
    if(_yaw_w < 0)
        _yaw_w = 0;
    NSLog(@"Myo on orientation data, pull : %d", _yaw_w);
    if(mode == 0)
            rolling = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0xE0 ], [NSNumber numberWithUnsignedInt:0x0C], [NSNumber numberWithUnsignedInt:_yaw_w],nil];
//    if(mode == 4)
//            rolling = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0xE0 ], [NSNumber numberWithUnsignedInt:0x0C], [NSNumber numberWithUnsignedInt:_roll_w],nil];
//    if(mode == 3)
//            rolling = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0xE1 ], [NSNumber numberWithUnsignedInt:0x0C], [NSNumber numberWithUnsignedInt:_roll_w],nil];
//    if(mode == 5)
//            rolling = [NSArray arrayWithObjects:[NSNumber numberWithUnsignedInt:0xE2 ], [NSNumber numberWithUnsignedInt:0x0C], [NSNumber numberWithUnsignedInt:_roll_w],nil];
//
//    
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
        case 0 :
            mode = 0;
            break;
        case 1:
            mode = 1;
            break;
            case 2:
            mode = 2;
            break;
        case 3:
            mode = 3;
            break;
        case 4:
            mode = 4;
            break;
        case 5:
            mode = 5;
            break;
        default:
            break;
    }
}

@end
