//
//  SKSharedAtles.h
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(int, SKTextureType) {
    SKTextureTypeBackground = 1,
    SKTextureTypeBackLayer = 2,
    SKTextureTypeCloud1 = 3,
    SKTextureTypeCloud2 = 4,
    SKTextureTypeHoney = 5,
    SKTextureTypeBird = 6,
    SKTextureTypeEnemy = 8,
    SKTextureTypeNest=11,//巢
    SKTextureTypeHoney1 = 12,
    SKTextureTypeHoney2 = 13,
    SKTextureTypeHoney3 = 14,
    SKTextureTypeHoney4 = 15,
    SKTextureTypeBackLayer2 = 16,
};

#define ZL_MAX_WALL_COUNT      6//墙块数目

@interface SKSharedAtles : SKTextureAtlas

+ (SKTexture *)textureWithType:(SKTextureType)type;


+ (SKAction *)playerAction;

+(SKTexture *)dropBird;
@end
