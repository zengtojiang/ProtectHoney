//
//  SKMainScene.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "ZLPlayerBird.h"
/**
 
 具有物理特性的物品的锚地必须在中心
 方法1：把两个body连接在一起，bodyA的密度小于1，bodyB的密度大于1，并且bodyA不能受重力影响，让bodyB带着bodyA运动，连接的锚点在bodyB的中心
 方法2：把两个body连接在一起，给bodyB施加作用力，带动bodyA运动，连接的锚点在bodyB上
 */
@interface SKMainScene : SKScene<SKPhysicsContactDelegate>{
    
    //位置
    int             _curPositionIndex;
    
    BOOL       _bGameOver;
    BOOL       _bPlayVoice;
    
    int         _birdVelocity;
    
    int         _wallGenerateTimer;
    int         _wallGeneratorDuration;//墙壁生成时间间隔
    int         _wallMoveSpeed;//墙移动速度
    
    int         _maxYWallCount;
    
    int         _cloud1Timer;
    int         _cloud2Timer;
    
    //过关记录
    int         _curPoints;//当前关卡
    int         _historyPoints;//历史关卡

    ZLPlayerBird    *_playerBird;
    ZLPlayerBird    *_playerHoney;
    SKLabelNode     *_historyPointLabel;
    SKLabelNode     *_pointLabel;
    SKSpriteNode    *_progressNode;
    
    SKSpriteNode    *_backLayer1;
    int             _adjustmentBackgroundPosition;
    int             _adjustmentBackLayerPosition;
     int             _adjustmentBackLayer2Position;
    SKSpriteNode    *_backLayer2;
    SKSpriteNode     *_groundNode1;
    SKSpriteNode     *_groundNode2;
    SKSpriteNode    *_backLayer3;
    SKSpriteNode    *_backLayer4;
    
    //音效加载
    SKAction        *_playFlapAudio;//拍翅膀
    SKAction        *_playGoldAudio;//捡到金币
    SKAction        *_playBombAudio;//碰到炸弹
    SKAction        *_playHitAudio;//碰到墙壁
    //SKAction        *_playNewRecordAudio;//刷新记录
}

@property(nonatomic,retain)NSMutableArray  *mArrPositions;

@end
