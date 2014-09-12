//
//  ZLAudioPlayer.h
//  Toothpaste
//
//  Created by libs on 14-3-23.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 音频播放
 */
#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef NS_ENUM(int, ZL_AUDIO_TYPE) {
    ZLAUDIOTYPEGOLD=1,
    ZLAUDIOTYPEHIT=2,
    ZLAUDIOTYPEBOMB=3,
    ZLAUDIOTYPEFLAP=4,
};


@interface ZLAudioPlayer : NSObject
{
    AVAudioPlayer *mPlayer;//背景音乐播放器
}

-(void)setBackgroundAudioFileName:(NSString *)fileName fileType:(NSString *)fileType;

-(void)play;

-(void)pause;

-(void)resume;

-(void)stop;

+(void)playAudioWithType:(ZL_AUDIO_TYPE)type;
@end
