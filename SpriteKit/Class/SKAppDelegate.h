//
//  SKAppDelegate.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZLAudioPlayer.h"

@interface SKAppDelegate : UIResponder <UIApplicationDelegate>
{
    ZLAudioPlayer   *mAudioPlayer;
}
@property (strong, nonatomic) UIWindow *window;
-(void)startBGAudio;

-(void)stopBGAudio;
@end
