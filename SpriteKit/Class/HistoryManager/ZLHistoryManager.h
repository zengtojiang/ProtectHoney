//
//  ZLHistoryManager.h
//  ScooterBoy
//
//  Created by libs on 14-3-16.
//  Copyright (c) 2014年 icow. All rights reserved.
//
/**
 历史记录保持器
 */
#import <Foundation/Foundation.h>

typedef NS_ENUM(int, ZL_GAME_DIFFICULTY) {
    ZL_DIFFICULTY_EASY=1,//简单
    ZL_DIFFICULTY_NORMAL=2,//普通
    ZL_DIFFICULTY_DIFFICULT=3,//困难
};

@interface ZLHistoryManager : NSObject


//get最新分数
+(int)getLastScore;

//set最新分数
+(void)setLastScore:(int)score;


//获取当前游戏难度
+(int)getDifficulty;

//设置游戏难度
+(void)setDifficulty:(ZL_GAME_DIFFICULTY)difficulty;

//get最新关卡
+(int)getLastPoints;

//set最新关卡
+(void)setLastPoints:(int)point;

//音效开关是否打开
+(BOOL)voiceOpened;

//设置音效开关
+(void)setVoiceOpened:(BOOL)open;

//背景音乐开关是否打开
+(BOOL)musicOpened;

//设置背景音乐开关
+(void)setMusicOpened:(BOOL)open;

//是否是第一次进入应用
+(BOOL)isFirstLaunch;

//设置为不是第一次进入应用
+(void)setFirstLaunch;
@end
