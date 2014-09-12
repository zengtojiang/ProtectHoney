//
//  SKMainScene.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKMainScene.h"
#import "ZLHistoryManager.h"
#import "SKSharedAtles.h"
#import "ZLAudioPlayer.h"


#define BIRD_ANCHOR_POINT       0.75f
#define DEFAULT_VELOCITY        (-230)
#define VELOCITY_CHANGE_DELTA   (20)

#define WALL_WIDTH                  70//  60//地板高度

#define BACKGROUND_HEIGHT             60// 34//51//  60//地板高度

#define HONEY_LINE_HEIGHT            WALL_WIDTH//  54//  60//宝贝保护伞高度

@implementation SKMainScene

- (instancetype)initWithSize:(CGSize)size{
    
    self = [super initWithSize:size];
    if (self) {
        
        //self.mArrPositions=[NSMutableArray array];
        [self initGameParams];
        [self initPhysicsWorld];
        [self initBackground];
        [self initScroe];
        [self initPlayerBird];
        [self initPlayerHoney];
        [self startPlayerBirdAction];
        [self initStartLabel:YES];
        [self initAudio];
        [_playerBird runAction:[SKSharedAtles playerAction]];
        //[self startPlayerHoneyAction];
        //[self initProgress];
        //[self resetBloodProgress];
        //重设游戏参数
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetGameMusic) name:ZL_RESET_GAME_NOTIFICATION object:nil];
         [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(restartNotification) name:ZL_RESTART_GAME_NOTIFICATION object:nil];
    }
    return self;
}

-(void)restartNotification
{
    [self initGameParams];
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            [child removeFromParent];
        }
    }
    [self removeAllActions];
    //[self removeAllChildren];
    //[self initBackground];
    [self initScroe];
    [self initPlayerBird];
    [self startPlayerBirdAction];
    [_playerBird runAction:[SKSharedAtles playerAction]];
    [self initStartLabel:YES];
    [self resetBloodProgress];
    [self initPlayerHoney];
    //[self startPlayerHoneyAction];
    //[self initProgress];
    //[self resetBloodProgress];
}

//初设游戏参数
-(void)initGameParams
{
    _bGameOver=YES;
    _maxYWallCount=((CGRectGetMaxY(self.frame)-BACKGROUND_HEIGHT-HONEY_LINE_HEIGHT)/WALL_WIDTH);//floorf
    //ZLTRACE(@"maxYWallCount height:%f :%d",(CGRectGetMaxY(self.frame)-BACKGROUND_HEIGHT),_maxYWallCount);
    _wallGeneratorDuration=35;
    _wallMoveSpeed=150;//4;
    [self resetGameMusic];
    [self resetParams];
}

-(void)resetGameMusic
{
    _bPlayVoice=[ZLHistoryManager voiceOpened];
}

//重置参数
-(void)resetParams
{
    _birdVelocity=0;
    _wallGenerateTimer=-1;
   // [self reloadPositionFile];
}

-(void)reloadPositionFile
{
    [self.mArrPositions removeAllObjects];
    NSString *fileName=[NSString stringWithFormat:@"position%d",arc4random()%3+1];
    ZLTRACE(@"fileName:%@",fileName);
    NSString  *filePath=[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"];
    [self.mArrPositions addObjectsFromArray:[NSArray arrayWithContentsOfFile:filePath]];
    //ZLTRACE(@"positionArray:%@",self.mArrPositions);
    _curPositionIndex=0;
}

-(void)onTapStartGame
{
    [self resetParams];
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            [child removeFromParent];
        }
    }
    //[self removeAllChildren];
    [self removeAllActions];
    //[self initBackground];
    [self initScroe];
    [self initPlayerBird];
    //[self initProgress];
    [self resetBloodProgress];
    [self initPlayerHoney];
    //[self startPlayerHoneyAction];
    [_playerBird runAction:[SKSharedAtles playerAction]];
    _playerBird.physicsBody.velocity=CGVectorMake(0, _birdVelocity);
    self.physicsWorld.speed=1.0;
    _bGameOver=NO;
    //self.physicsWorld.gravity=CGVectorMake(0, DEFAULT_GRAVITY+_forceGravity);
}


- (void)initPhysicsWorld{
    self.physicsWorld.contactDelegate = self;
    self.physicsWorld.gravity = CGVectorMake(0,-6);
    //self.physicsWorld.
}

-(void)initAudio
{
    //waitForCompletion 音效动作是否和音效长度一样
    //捡到金币
    _playGoldAudio=[SKAction playSoundFileNamed:@"F_colonna.wav" waitForCompletion:NO];//@"select_YN.wav"
    //拍翅膀
    _playFlapAudio=[SKAction playSoundFileNamed:@"wingflap.mp3" waitForCompletion:NO];
    
    //碰到墙壁
    _playHitAudio=[SKAction playSoundFileNamed:@"hit.mp3" waitForCompletion:YES];
    //碰到炸弹
    _playBombAudio=[SKAction playSoundFileNamed:@"die.mp3" waitForCompletion:YES];
    //_playNewRecordAudio=[SKAction playSoundFileNamed:@"select.mp3" waitForCompletion:NO];
}

- (void)initBackground{
    _cloud1Timer=-1;
    _cloud2Timer=-1;
    _adjustmentBackgroundPosition = self.size.width;
    
    SKTexture *layer1Texture=[SKSharedAtles textureWithType:SKTextureTypeBackLayer];
    _adjustmentBackLayerPosition=layer1Texture.size.width;
    SKTexture *groundTexture=[SKSharedAtles textureWithType:SKTextureTypeBackground];
    
    
    _backLayer1 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer1.position = CGPointMake(_adjustmentBackLayerPosition-layer1Texture.size.width, groundTexture.size.height-10);
    _backLayer1.anchorPoint = CGPointMake(0, 0);
    _backLayer1.zPosition = 0;
    
    _backLayer2 = [SKSpriteNode spriteNodeWithTexture:layer1Texture];
    _backLayer2.anchorPoint = CGPointMake(0, 0);
    _backLayer2.position = CGPointMake(_adjustmentBackLayerPosition-1, groundTexture.size.height);
    _backLayer2.zPosition = 0;
    
    [self addChild:_backLayer1];
    [self addChild:_backLayer2];
    
    _groundNode1=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode1.position=CGPointMake(_adjustmentBackgroundPosition-groundTexture.size.width, groundTexture.size.height/2);
    _groundNode1.anchorPoint=CGPointMake(0, 0.5);
    _groundNode1.zPosition=0;
    _groundNode1.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_groundNode1.size];
    //groundSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:groundSprite.size];
    _groundNode1.physicsBody.categoryBitMask=SKRoleCategoryBackground;
    _groundNode1.physicsBody.contactTestBitMask=SKRoleCategoryBird;
    _groundNode1.physicsBody.dynamic=NO;
    _groundNode1.physicsBody.restitution=0;
    [self addChild:_groundNode1];
    
    _groundNode2=[SKSpriteNode spriteNodeWithTexture:groundTexture];
    _groundNode2.position=CGPointMake(_adjustmentBackgroundPosition-1, groundTexture.size.height/2);
    _groundNode2.anchorPoint=CGPointMake(0, 0.5);
    _groundNode2.zPosition=0;
    _groundNode2.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:_groundNode2.size];
    _groundNode2.physicsBody.categoryBitMask=SKRoleCategoryBackground;
    _groundNode2.physicsBody.contactTestBitMask=SKRoleCategoryBird;
    _groundNode2.physicsBody.dynamic=NO;
    _groundNode2.physicsBody.restitution=0;
    [self addChild:_groundNode2];
    
    
    SKTexture *layer2Texture=[SKSharedAtles textureWithType:SKTextureTypeBackLayer2];
    _adjustmentBackLayer2Position=layer2Texture.size.width;
    
    _backLayer3 = [SKSpriteNode spriteNodeWithTexture:layer2Texture];
    _backLayer3.position = CGPointMake(_adjustmentBackLayer2Position-layer2Texture.size.width, groundTexture.size.height-20);
    _backLayer3.anchorPoint = CGPointMake(0, 0);
    _backLayer3.zPosition = 0;
    
    _backLayer4 = [SKSpriteNode spriteNodeWithTexture:layer2Texture];
    _backLayer4.anchorPoint = CGPointMake(0, 0);
    _backLayer4.position = CGPointMake(_adjustmentBackLayer2Position-1, groundTexture.size.height-20);
    _backLayer4.zPosition = 0;
    
    [self addChild:_backLayer3];
    [self addChild:_backLayer4];
    
}

- (void)scrollBackground{
    _adjustmentBackgroundPosition -=5;
    _adjustmentBackLayerPosition -=2;
    _adjustmentBackLayer2Position -=5;
    if (_adjustmentBackgroundPosition <= 0)
    {
        _adjustmentBackgroundPosition = self.size.width;
    }
    if (_adjustmentBackLayerPosition<=0) {
        _adjustmentBackLayerPosition=_backLayer1.size.width;
    }
    if (_adjustmentBackLayer2Position<=0) {
        _adjustmentBackLayer2Position=_backLayer3.size.width;
    }
    float layer1YPosition=_backLayer1.position.y;
     float layer2YPosition=_backLayer3.position.y;
    float groundYPosition=_groundNode1.position.y;
    [_backLayer1 setPosition:CGPointMake(_adjustmentBackLayerPosition - _backLayer1.size.width, layer1YPosition)];
    [_backLayer2 setPosition:CGPointMake(_adjustmentBackLayerPosition-1, layer1YPosition)];
    [_backLayer3 setPosition:CGPointMake(_adjustmentBackLayer2Position - _backLayer3.size.width, layer2YPosition)];
    [_backLayer4 setPosition:CGPointMake(_adjustmentBackLayer2Position-1, layer2YPosition)];
    [_groundNode1 setPosition:CGPointMake(_adjustmentBackgroundPosition - self.size.width, groundYPosition)];
    [_groundNode2 setPosition:CGPointMake(_adjustmentBackgroundPosition-1, groundYPosition)];
}

- (void)initStartLabel:(BOOL)firsttime
{
    SKLabelNode *_startLabel = [SKLabelNode labelNodeWithFontNamed:@"ChalkboardSE-Bold"];
    _startLabel.text = firsttime?@"Tap to Start":@"Tap to Restart";
    _startLabel.name=@"startLabel";
    _startLabel.zPosition = 4;
    _startLabel.fontColor = HEXCOLOR(0xe6b003);//HEXCOLOR(0x552d19);//[SKColor brownColor];
    _startLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _startLabel.position = CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame));
    [self addChild:_startLabel];
    [_startLabel runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction fadeOutWithDuration:1],[SKAction waitForDuration:0.1],[SKAction fadeInWithDuration:1.5],[SKAction waitForDuration:0.1]]]]];
}

- (void)initScroe{
    _curPoints=0;
    _historyPoints=[ZLHistoryManager getLastPoints];
    _pointLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _pointLabel.text = [NSString stringWithFormat:@"Score:%d",_curPoints];
    _pointLabel.zPosition = 4;
    _pointLabel.fontSize=16;
    _pointLabel.fontColor = HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    _pointLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeLeft;
    _pointLabel.position = CGPointMake(60 , self.size.height - 50);
    [self addChild:_pointLabel];
    
    _historyPointLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _historyPointLabel.text = [NSString stringWithFormat:@"Record:%d",_historyPoints];
    _historyPointLabel.zPosition = 4;
    _historyPointLabel.fontColor = HEXCOLOR(0xe6b003);//[SKColor whiteColor];
    _historyPointLabel.fontSize=16;
    _historyPointLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentModeCenter;
    _historyPointLabel.position = CGPointMake(CGRectGetMidX(self.frame)+60 , self.size.height - 50);
    [self addChild:_historyPointLabel];
}

-(void)resetBloodProgress
{
    SKTextureType honeyTexture=SKTextureTypeHoney;
    if (_playerBird.blood==ZL_DEFAULT_BLOOD-1) {
        honeyTexture=SKTextureTypeHoney1;
    }else if (_playerBird.blood==ZL_DEFAULT_BLOOD-2) {
        honeyTexture=SKTextureTypeHoney2;
    }if (_playerBird.blood==ZL_DEFAULT_BLOOD-3) {
        honeyTexture=SKTextureTypeHoney3;
    }if (_playerBird.blood==ZL_DEFAULT_BLOOD-4) {
        honeyTexture=SKTextureTypeHoney4;
    }
    //[_playerHoney runAction:[SKAction setTexture:[SKSharedAtles textureWithType:honeyTexture]]];
    [_playerHoney setTexture:[SKSharedAtles textureWithType:honeyTexture]];
    /*
    float scale=0.1f*_playerBird.blood/ZL_DEFAULT_BLOOD;
    //[_progressNode runAction:[SKAction scaleXTo:scale duration:_playerBird.blood==ZL_DEFAULT_BLOOD?0:0.1]];
    SKTexture *texture=[SKSharedAtles textureWithType:SKTextureTypeProgress];
    _progressNode.size=CGSizeMake(scale*texture.size.width, texture.size.height);
     */
}

- (void)initPlayerBird{
    
    _playerBird = [ZLPlayerBird spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeBird]];
    _playerBird.position =  CGPointMake(CGRectGetMidX(self.frame),CGRectGetMidY(self.frame)+50);//CGPointMake(160, 300);
    _playerBird.zPosition = 2;
   // _playerBird.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerBird.size];
    _playerBird.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:_playerBird.size.width/3];
    _playerBird.physicsBody.categoryBitMask = SKRoleCategoryBird;
    _playerBird.physicsBody.collisionBitMask = SKRoleCategoryBackground;
    _playerBird.physicsBody.affectedByGravity=NO;
    _playerBird.physicsBody.contactTestBitMask = SKRoleCategoryBackground|SKRoleCategoryEnemy;
    [self addChild:_playerBird];
    _playerBird.blood=ZL_DEFAULT_BLOOD;
    //[_playerPlane runAction:[SKSharedAtles playerPlaneAction]];
}

-(void)initPlayerHoney
{
    SKTexture *nestTexture=[SKSharedAtles textureWithType:SKTextureTypeNest];
    
    SKSpriteNode *nestNode = [SKSpriteNode spriteNodeWithTexture:nestTexture];
   // nestNode.position =  CGPointMake(_playerHoney.position.x,BACKGROUND_HEIGHT+nestNode.size.height/2);
    nestNode.position =  CGPointMake(nestTexture.size.width/2+3,nestTexture.size.height/2+3);//CGPointMake(160, 300);
    nestNode.zPosition = 1;
    [self addChild:nestNode];
    
    _playerHoney = [ZLPlayerBird spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeHoney]];
    _playerHoney.position =  CGPointMake(nestNode.position.x,_playerHoney.size.height/2+nestNode.position.y);//CGPointMake(160, 300);
     //_playerHoney.position =  CGPointMake(_playerHoney.size.width/2,BACKGROUND_HEIGHT+_playerHoney.size.height/2+nestTexture.size.height-15);
    _playerHoney.zPosition = 1;
    _playerHoney.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_playerHoney.size];
    //_playerHoney.physicsBody=[SKPhysicsBody bodyWithCircleOfRadius:_playerHoney.size.width/3];
    _playerHoney.physicsBody.categoryBitMask = SKRoleCategoryHoney;
    _playerHoney.physicsBody.collisionBitMask = 0;
    _playerHoney.physicsBody.affectedByGravity=NO;
    _playerHoney.physicsBody.contactTestBitMask = SKRoleCategoryBrick;
    [self addChild:_playerHoney];
    
    [self startPlayerHoneyAction];
}

-(void)startPlayerHoneyAction
{
   // [_playerHoney runAction:[SKAction rotateToAngle:0 duration:0]];
    [_playerHoney runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveByX:0 y:3 duration:0.1],[SKAction moveByX:0 y:-3 duration:0.1],[SKAction moveByX:0 y:3 duration:0.1],[SKAction moveByX:0 y:-3 duration:0.1],[SKAction waitForDuration:0.1],[SKAction rotateByAngle:M_1_PI duration:0.1],[SKAction rotateByAngle:-2*M_1_PI duration:0.2],[SKAction rotateByAngle:M_1_PI duration:0.1],[SKAction waitForDuration:0.2]]]]];
}

-(void)startPlayerBirdAction
{
    [_playerBird runAction:[SKAction repeatActionForever:[SKAction sequence:@[[SKAction moveByX:0 y:15 duration:0.5],[SKAction waitForDuration:0.1],[SKAction moveByX:0 y:-30 duration:1],[SKAction waitForDuration:0.1],[SKAction moveByX:0 y:15 duration:0.5]]]]];
}

-(SKSpriteNode *)createEnemy
{
    int wallCount= (arc4random() % _maxYWallCount);
    
    //wallHeight=(CGRectGetHeight(self.frame)-wallCount*WALL_WIDTH-_wallGapHeight-BACKGROUND_HEIGHT);
    // int _bombYPosition=(arc4random() % (lround(CGRectGetHeight(self.frame)-100-BACKGROUND_HEIGHT))) + 100;
    int _wallYPosition=CGRectGetMinY(self.frame)+(wallCount+0.5f)*WALL_WIDTH+BACKGROUND_HEIGHT+HONEY_LINE_HEIGHT;
    SKSpriteNode *wallSprite=[SKSpriteNode spriteNodeWithTexture:[SKSharedAtles textureWithType:SKTextureTypeEnemy]];
    wallSprite.anchorPoint=CGPointMake(0.5, 0.5);
    wallSprite.position=CGPointMake(CGRectGetMaxX(self.frame)+wallSprite.size.width/2, _wallYPosition);
    wallSprite.zPosition=1;
    wallSprite.physicsBody=[SKPhysicsBody bodyWithRectangleOfSize:wallSprite.size];
    wallSprite.physicsBody.categoryBitMask=SKRoleCategoryEnemy;
    wallSprite.physicsBody.collisionBitMask = SKRoleCategoryHoney;
    wallSprite.physicsBody.contactTestBitMask=SKRoleCategoryBird|SKRoleCategoryBorder|SKRoleCategoryHoney;
    //wallSprite.physicsBody.dynamic=NO;
    wallSprite.physicsBody.affectedByGravity=NO;
    wallSprite.physicsBody.restitution=0;
    return wallSprite;
}

-(void)createClouds
{
    if (_cloud1Timer>=100||_cloud1Timer==-1) {
        SKTexture *cloud1Texture=[SKSharedAtles textureWithType:SKTextureTypeCloud1];
        SKSpriteNode *cloudSprite=[SKSpriteNode spriteNodeWithTexture:cloud1Texture];
        int yPosition=arc4random()%150+BACKGROUND_HEIGHT+80+cloud1Texture.size.height/2;
        cloudSprite.anchorPoint=CGPointMake(0.5, 0.5);
        cloudSprite.zPosition=0;
        cloudSprite.position=CGPointMake(CGRectGetMaxX(self.frame)+cloud1Texture.size.width/2, yPosition);
        [self addChild:cloudSprite];
        [cloudSprite runAction:[SKAction sequence:@[[SKAction moveToX:-cloud1Texture.size.width/2 duration:6],[SKAction removeFromParent]]]];
        _cloud1Timer=0;
    }
    
    if (_cloud2Timer>=160||_cloud2Timer==-1) {
        SKTexture *cloud1Texture=[SKSharedAtles textureWithType:SKTextureTypeCloud2];
        SKSpriteNode *cloudSprite=[SKSpriteNode spriteNodeWithTexture:cloud1Texture];
        int yPosition=arc4random()%lround(CGRectGetHeight(self.frame)-BACKGROUND_HEIGHT-220)+BACKGROUND_HEIGHT+220+cloud1Texture.size.height/2;
        cloudSprite.anchorPoint=CGPointMake(0.5, 0.5);
        cloudSprite.zPosition=0;
        cloudSprite.position=CGPointMake(CGRectGetMaxX(self.frame)+cloud1Texture.size.width/2, yPosition);
        [self addChild:cloudSprite];
        [cloudSprite runAction:[SKAction sequence:@[[SKAction moveToX:-cloud1Texture.size.width/2 duration:10],[SKAction removeFromParent]]]];
        
         _cloud2Timer=0;
    }
    _cloud1Timer++;
    _cloud2Timer++;
}

-(void)createIncomingWallBombAndCoins
{
    if (_wallGenerateTimer >= _wallGeneratorDuration)
    {
        SKSpriteNode *wallNode = [self createEnemy];
        [self addChild:wallNode];
        [wallNode runAction:[SKAction sequence:@[[SKAction moveToX:wallNode.size.width/2 duration:(wallNode.position.x-wallNode.size.width/2)/_wallMoveSpeed],[SKAction runBlock:^
        {
            [self enemyCollisionWithBorder:wallNode];
            
        }]]]];
       // [wallNode runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
        
        _wallGenerateTimer = 0;
    }
    _wallGenerateTimer++;
}

/*
-(void)createIncomingWallBombAndCoins2
{
    _wallGenerateTimer++;
    if (_wallGenerateTimer >= _wallGeneratorDuration)
    {
        if (_curPositionIndex>=[self.mArrPositions count]) {
            //重新加载位置文件
            [self reloadPositionFile];
            //_curPositionIndex=0;
        }
        if (_curPositionIndex<[self.mArrPositions count]) {
            NSString *positionStr=[self.mArrPositions objectAtIndex:_curPositionIndex];
            NSArray *posItemArray=[positionStr componentsSeparatedByString:@";"];
            if (posItemArray&&[posItemArray count]) {
                NSString *wallPosStr=[posItemArray objectAtIndex:0];
                if (wallPosStr&&[wallPosStr length]) {
                    NSArray *wallPosArr=[wallPosStr componentsSeparatedByString:@","];
                    for (int i=0; i<[wallPosArr count]; i++) {
                        SKSpriteNode *wallNode = [self createWallAtPosition:[[wallPosArr objectAtIndex:i] intValue]];
                        [self addChild:wallNode];
                        [wallNode runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
                    }
                }
                NSString *coinPosStr=[posItemArray objectAtIndex:1];
                if (coinPosStr&&[coinPosStr length]) {
                    NSArray *coinPosArr=[coinPosStr componentsSeparatedByString:@","];
                    for (int i=0; i<[coinPosArr count]; i++) {
                        int coinRand=arc4random() % (12);
                        if (coinRand==0) {
                            SKSpriteNode *bomeNode=[self createBombAtPosition:[[coinPosArr objectAtIndex:i] intValue]];
                            [self addChild:bomeNode];
                            [bomeNode runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
                        }else{
                            ZLCoinNode *coinSprite = [self createCoinAtPosition:[[coinPosArr objectAtIndex:i] intValue]];
                            [self addChild:coinSprite];
                            [coinSprite runAction:[SKAction sequence:@[[SKAction moveToX:-WALL_WIDTH/2 duration:_wallMoveSpeed],[SKAction removeFromParent]]]];
                        }
                    }
                }
            }
        }
        _curPositionIndex++;
        _wallGenerateTimer = 0;
    }
}
*/

-(void)adjustPlayerBirdAngle
{
    CGVector velocity=_playerBird.physicsBody.velocity;
    if (velocity.dy>0) {
        [_playerBird removeActionForKey:@"turndownaction"];
        if (![_playerBird actionForKey:@"turnupaction"]) {
            [_playerBird runAction:[SKAction rotateToAngle:0 duration:0.1f]];
            //[_playerBird runAction:[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeBirdUp]]];
            SKAction *rotateAction=[SKAction rotateToAngle:M_PI_4 duration:0.3f];
            rotateAction.timingMode=SKActionTimingEaseOut;
            [_playerBird runAction:rotateAction withKey:@"turnupaction"];
        }
    }else{
        [_playerBird removeActionForKey:@"turnupaction"];
        if (![_playerBird actionForKey:@"turndownaction"]) {
            //[_playerBird runAction:[SKAction setTexture:[SKSharedAtles textureWithType:SKTextureTypeBirdDown]]];
            SKAction *rotateAction=[SKAction rotateToAngle:M_PI_4*(-1) duration:0.5f];
            rotateAction.timingMode=SKActionTimingEaseIn;
            [_playerBird runAction:rotateAction withKey:@"turndownaction"];
        }
    }
}

-(void)applyForceToPlayer
{
    
        //if (_birdVelocity>DEFAULT_VELOCITY&&_birdVelocity<=0)
        if (_birdVelocity<=0&&_birdVelocity>DEFAULT_VELOCITY)
        {
            _birdVelocity -=VELOCITY_CHANGE_DELTA;
        }else if(_birdVelocity>0){
            _birdVelocity -=VELOCITY_CHANGE_DELTA;
        }
        ZLTRACE(@"_birdVelocity:%d",_birdVelocity);
        _playerBird.physicsBody.velocity=CGVectorMake(0, _birdVelocity);
    //}
    
    //self.physicsWorld.gravity=CGVectorMake(0, DEFAULT_GRAVITY+_forceGravity);
    //[_massNode.physicsBody applyImpulse:CGVectorMake(0, -2+_tapForce) atPoint:CGPointMake(_playerBird.size.width*BIRD_ANCHOR_POINT, _playerBird.size.height/2)];
    
    //[_playerBird.physicsBody applyForce:CGVectorMake(0, -20)];
    //[_massNode.physicsBody applyImpulse:CGVectorMake(0, -2+_tapForce)];
    //[_playerBird.physicsBody applyImpulse:CGVectorMake(0, -2+_tapForce) atPoint:CGPointMake(BIRD_ANCHOR_POINT, 0.5)];
}

-(void)birdCollisionWithEnemy:(SKSpriteNode *)sprite
{
    _curPoints +=1;
    [sprite removeAllActions];
    [sprite removeFromParent];
    [_pointLabel runAction:[SKAction runBlock:^{
        _pointLabel.text = [NSString stringWithFormat:@"Score:%d",_curPoints];
    }]];
    if (_bPlayVoice) {
        [self runAction:_playGoldAudio];
        //[ZLAudioPlayer playAudioWithType:ZLAUDIOTYPEGOLD];
    }
    if (_curPoints>_historyPoints) {
        [ZLHistoryManager setLastPoints:_curPoints];
        _historyPoints=[ZLHistoryManager getLastPoints];
        [_historyPointLabel runAction:[SKAction runBlock:^{
            _historyPointLabel.text = [NSString stringWithFormat:@"Record:%d",_historyPoints];
        }]];
        //        [_historyPointLabel runAction:[SKAction sequence:@[_playNewRecordAudio,[SKAction runBlock:^{
        //            _historyPointLabel.text = [NSString stringWithFormat:@"Record:%d",_historyPoints];
        //        }]]]];
    }
}

-(void)enemyCollisionWithBorder:(SKSpriteNode *)enemy
{
    //float enemyYPosition=enemy.position.y;
    /*
    [enemy runAction:[SKAction fadeOutWithDuration:1] completion:^{
        [enemy removeFromParent];
    }];
    */
    /*
   SKSpriteNode *brickNode=[self createBrickAtPosition:enemyYPosition];
    brickNode.alpha=0;
    [self addChild:brickNode];
     [brickNode runAction:[SKAction sequence:@[[SKAction fadeInWithDuration:1],dropAction,[SKAction runBlock:^{
     _playerBird.blood--;
     [brickNode removeFromParent];
     [self resetBloodProgress];
     if (_playerBird.blood<=0) {
     [self onGameOverWithType:2];
     }
     }]]]];
    */
    enemy.physicsBody.affectedByGravity=YES;
   // [enemy.physicsBody applyImpulse:CGVectorMake(0,-20)];
    //[enemy runAction:];
    /*
    SKAction *dropAction=[SKAction moveToY:BACKGROUND_HEIGHT duration:(enemyYPosition-BACKGROUND_HEIGHT)/150];
    dropAction.timingMode=SKActionTimingEaseIn;
    [enemy runAction:[SKAction sequence:@[dropAction,[SKAction runBlock:^{
        _playerBird.blood--;
        [enemy removeFromParent];
        [self resetBloodProgress];
        if (_playerBird.blood<=0) {
            [self onGameOverWithType:2];
        }
    }]]]];
    */
}

-(void)onEnemyCollisionWithHoney:(SKSpriteNode *)enemy
{
    [enemy removeAllActions];
    [enemy removeFromParent];
    _playerBird.blood--;
   
    [self resetBloodProgress];
    if (_playerBird.blood<=0) {
        [self onGameOverWithType:2];
    }else{
         [_playerHoney runAction:_playHitAudio];
    }
}

/**
 overType =1 碰到墙壁
 overType=2  碰到炸弹
 */
-(void)onGameOverWithType:(int)overType
{
    if (_bGameOver) {
        return;
    }
    _bGameOver=YES;
    [self removeAllActions];
//    if (overType==1) {
//        [_playerBird setTexture:[SKSharedAtles dropBird]];
//    }
//    _playerBird.physicsBody.velocity=CGVectorMake(0, 0);
//    _playerBird.physicsBody.angularVelocity=0;
    //_playerBird.physicsBody.resting=YES;
   // self.physicsWorld.speed=0;
    for (SKNode *child in [self children]) {
        if (child.zPosition!=0) {
            child.physicsBody.resting=YES;
            [child removeAllActions];
        }
    }
    [_playerHoney removeAllActions];
    SKAction *dieAudio=_playBombAudio;
    /*
    if (overType==1) {
        dieAudio=_playHitAudio;
    }else{
        dieAudio=_playBombAudio;
    }
     */
    if (_bPlayVoice) {
        [self runAction:[SKAction sequence:@[dieAudio,[SKAction runBlock:^{
            [self initStartLabel:NO];
            
        }]]]];
    }else{
        [self runAction:[SKAction runBlock:^{
            [self initStartLabel:NO];
        }]];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    ZLTRACE(@"");
    if (self.paused) {
        ZLTRACE(@"game has paused");
        return;
    }
    if (_bGameOver) {
        if ([self childNodeWithName:@"startLabel"]) {
            //出现了点击开始图标才能开始
            [self onTapStartGame];
        }
    }else{
        if (_bPlayVoice) {
            // [ZLAudioPlayer playAudioWithType:ZLAUDIOTYPEFLAP];
            [self runAction:_playFlapAudio];
        }
        _birdVelocity=DEFAULT_VELOCITY*(-1);
        //[_playerBird.physicsBody applyImpulse:CGVectorMake(0,50)];
    }
}
/*
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    
    for (UITouch *touch in touches) {
        
        CGPoint location = [touch locationInNode:self];
        
        if (location.x >= self.size.width - (_playerPlane.size.width / 2)) {
            
            location.x = self.size.width - (_playerPlane.size.width / 2);
            
        }else if (location.x <= (_playerPlane.size.width / 2)) {
            
            location.x = _playerPlane.size.width / 2;
            
        }
        
        if (location.y >= self.size.height - (_playerPlane.size.height / 2)) {
            
            location.y = self.size.height - (_playerPlane.size.height / 2);
            
        }else if (location.y <= (_playerPlane.size.height / 2)) {
            
            location.y = (_playerPlane.size.height / 2);
            
        }
        
        SKAction *action = [SKAction moveTo:CGPointMake(location.x, location.y) duration:0];
        
        [_playerPlane runAction:action];
    }
}
*/

- (void)update:(NSTimeInterval)currentTime{
    [self scrollBackground];
    [self createClouds];
    if (!_bGameOver) {
        [self applyForceToPlayer];
        
        [self adjustPlayerBirdAngle];
        //[self createIncomingWalls];
        //[self createIncomingWallBombAndCoins2];
        [self createIncomingWallBombAndCoins];
    }
}

#pragma mark -
- (void)didBeginContact:(SKPhysicsContact *)contact{
    if (contact.bodyA.categoryBitMask & SKRoleCategoryBird || contact.bodyB.categoryBitMask & SKRoleCategoryBird) {
        
        //if (contact.bodyA.categoryBitMask & SKRoleCategoryBird || contact.bodyB.categoryBitMask & SKRoleCategoryBird)
        //SKSpriteNode *honeySprite = (contact.bodyA.categoryBitMask & SKRoleCategoryHoney) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
        //ZLTRACE(@"collision bodyA category:%d bodyB category:%d",contact.bodyA.categoryBitMask,contact.bodyB.categoryBitMask);
        if (contact.bodyA.categoryBitMask & SKRoleCategoryEnemy || contact.bodyB.categoryBitMask & SKRoleCategoryEnemy) {
            ZLTRACE(@"bird collision with enemy");
            SKSpriteNode *wallSprite = (contact.bodyA.categoryBitMask & SKRoleCategoryEnemy) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self birdCollisionWithEnemy:wallSprite];
        }else if(contact.bodyA.categoryBitMask & SKRoleCategoryBackground || contact.bodyB.categoryBitMask & SKRoleCategoryBackground){
            ZLTRACE(@"bird collision with background");
            [self onGameOverWithType:1];
        }
    }
    
    else if (contact.bodyA.categoryBitMask & SKRoleCategoryEnemy || contact.bodyB.categoryBitMask & SKRoleCategoryEnemy)
    {
       
        if(contact.bodyA.categoryBitMask & SKRoleCategoryHoney || contact.bodyB.categoryBitMask & SKRoleCategoryHoney){
            ZLTRACE(@"enemy collision with honey");
             SKSpriteNode *enemySprite = (contact.bodyA.categoryBitMask & SKRoleCategoryEnemy) ? (SKSpriteNode *)contact.bodyA.node : (SKSpriteNode *)contact.bodyB.node;
            [self onEnemyCollisionWithHoney:enemySprite];
            //[self onGameOverWithType:1];
        }
    }
}

- (void)didEndContact:(SKPhysicsContact *)contact{
}


@end
