//
//  ZLAudioPlayer.m
//  Toothpaste
//
//  Created by libs on 14-3-23.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLAudioPlayer.h"

@implementation ZLAudioPlayer

-(void)setBackgroundAudioFileName:(NSString *)fileName fileType:(NSString *)fileType
{
    NSString *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:fileType];
    mPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL];
    mPlayer.numberOfLoops=-1;
}

-(void)play
{
    [mPlayer play];
}

-(void)pause
{
    [mPlayer pause];
}

-(void)resume
{
    [mPlayer play];
}

-(void)stop
{
    [mPlayer stop];
}

+(void)playAudioWithType:(ZL_AUDIO_TYPE)type
{
    NSString *fileName=nil;
    switch (type) {
        case ZLAUDIOTYPEFLAP:
            fileName=@"wingflap";
            break;
        case ZLAUDIOTYPEGOLD:
            fileName=@"mission";
            break;
        case ZLAUDIOTYPEHIT:
            fileName=@"hit";
            break;
        case ZLAUDIOTYPEBOMB:
            fileName=@"bomb";
            break;
        default:
            break;
    }
    ZLTRACE(@"fileName:%@",fileName);
    NSString *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"mp3"];
    AVAudioPlayer *audioPlayer=[[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:filePath] error:NULL];
    audioPlayer.numberOfLoops=1;
    [audioPlayer play];
}

@end
