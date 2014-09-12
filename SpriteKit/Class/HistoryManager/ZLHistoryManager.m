//
//  ZLHistoryManager.m
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//

#import "ZLHistoryManager.h"

@implementation ZLHistoryManager

#define ZL_POTATO_KEY   @"ZL_POTATO_KEY"
#define ZL_GOLD_KEY     @"ZL_GOLD_KEY"



//get最新分数
+(int)getLastScore
{
    return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_SCORE"];
}

//set最新分数
+(void)setLastScore:(int)score
{
    [[NSUserDefaults standardUserDefaults] setInteger:score forKey:@"ZL_LAST_SCORE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//获取当前游戏难度
+(int)getDifficulty;
{
    int difficulty=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_GAME_DIFFICULTY"];
    if (difficulty<=0) {
        return ZL_DIFFICULTY_NORMAL;
    }
    return difficulty;
}

//设置游戏难度
+(void)setDifficulty:(ZL_GAME_DIFFICULTY)difficulty;
{
    if (difficulty<ZL_DIFFICULTY_EASY||difficulty>ZL_DIFFICULTY_DIFFICULT) {
        return;
    }
    [[NSUserDefaults standardUserDefaults] setInteger:difficulty forKey:@"ZL_GAME_DIFFICULTY"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//get最新关卡
+(int)getLastPoints
{
     return (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_LAST_POINTS"];
}

//set最新关卡
+(void)setLastPoints:(int)point
{
    [[NSUserDefaults standardUserDefaults] setInteger:point forKey:@"ZL_LAST_POINTS"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

//音效开关是否打开
+(BOOL)voiceOpened
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_VOICE_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_VOICE_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//背景音乐开关是否打开
+(BOOL)musicOpened;
{
    int voiceState=(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"ZL_MUSIC_STATE"];
    if (voiceState==2) {
        return NO;
    }
    return YES;
}

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;
{
    [[NSUserDefaults standardUserDefaults] setInteger:open?1:2 forKey:@"ZL_MUSIC_STATE"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//是否是第一次进入应用
+(BOOL)isFirstLaunch
{
    BOOL launched=[[NSUserDefaults standardUserDefaults] boolForKey:@"ZL_LAUNCHED"];
    if (!launched) {
        return YES;
    }
    return NO;
}

//设置为不是第一次进入应用
+(void)setFirstLaunch
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ZL_LAUNCHED"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
