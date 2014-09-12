//
//  SKSharedAtles.m
//  SpriteKit
//
//  Created by Ray on 14-1-20.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "SKSharedAtles.h"

static SKSharedAtles *_shared = nil;

@implementation SKSharedAtles


+ (instancetype)shared{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = (SKSharedAtles *)[SKSharedAtles atlasNamed:@"Flap"];
    });
    return _shared;
}


+ (SKTexture *)textureWithType:(SKTextureType)type{
    
    switch (type) {
        case SKTextureTypeBackground:
        {
            /*
            UIImage *imageTile = [UIImage imageNamed:@"ground3.png"];
            CGRect  textureRect = CGRectMake(0, 0, imageTile.size.width, imageTile.size.height);
            UIGraphicsBeginImageContext(CGSizeMake(320, imageTile.size.height));//[[UIScreen mainScreen] currentMode].size
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextRotateCTM(context, M_PI); //先旋转180度，是按照原先顺时针方向旋转的。这个时候会发现位置偏移了
            CGContextScaleCTM(context, -1, 1); //再水平旋转一下
            CGContextTranslateCTM(context,0, -imageTile.size.height);
            CGContextDrawTiledImage(context, textureRect, imageTile.CGImage);
            UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [SKTexture textureWithCGImage:retImage.CGImage];
            */
            return [[[self class] shared] textureNamed:@"ground7.png"];
        }
            break;
        case SKTextureTypeBackLayer:
            return [SKTexture textureWithImageNamed:@"bg4.png"];
            return [[[self class] shared] textureNamed:@"bg_layer.png"];
            break;
        case SKTextureTypeBackLayer2:
            //return [SKTexture textureWithImageNamed:@"bg_layer2.png"];
            return [[[self class] shared] textureNamed:@"layer2.png"];
            break;
        case SKTextureTypeCloud1:
            return [[[self class] shared] textureNamed:@"cloud1.png"];
            break;
        case SKTextureTypeCloud2:
            return [[[self class] shared] textureNamed:@"cloud2.png"];
            break;
        case SKTextureTypeBird:
            return [[[self class] shared] textureNamed:@"bird1.png"];
            break;
        case SKTextureTypeHoney:
            return [[[self class] shared] textureNamed:@"honey0.png"];
            break;
        case SKTextureTypeHoney1:
            return [[[self class] shared] textureNamed:@"honey1.png"];
            break;
        case SKTextureTypeHoney2:
            return [[[self class] shared] textureNamed:@"honey2.png"];
            break;
        case SKTextureTypeHoney3:
            return [[[self class] shared] textureNamed:@"honey3.png"];
            break;
        case SKTextureTypeHoney4:
            return [[[self class] shared] textureNamed:@"honey4.png"];
            break;
        case SKTextureTypeNest:
            return [[[self class] shared] textureNamed:@"honeyNest.png"];
            break;
        case SKTextureTypeEnemy:
        {
            int aiIndex=arc4random()%11+1;
            return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"a%d.png",aiIndex]];
        }
            break;
        /*
        case SKTextureTypeWall:
        {
            UIImage *imageTile = [UIImage imageNamed:@"wall_tile.png"];
            CGRect  textureRect = CGRectMake(0, 0, imageTile.size.width, imageTile.size.height);
            UIGraphicsBeginImageContext(CGSizeMake(imageTile.size.width, imageTile.size.height*ZL_MAX_WALL_COUNT));
            CGContextRef context = UIGraphicsGetCurrentContext();
            CGContextRotateCTM(context, M_PI); //先旋转180度，是按照原先顺时针方向旋转的。这个时候会发现位置偏移了
            CGContextScaleCTM(context, -1, 1); //再水平旋转一下
            CGContextTranslateCTM(context,0, -imageTile.size.height);
            CGContextDrawTiledImage(context, textureRect, imageTile.CGImage);
            UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            return [SKTexture textureWithCGImage:retImage.CGImage];
        }
            break;
             */
        default:
            break;
    }
    return nil;
}

+ (SKTexture *)playerTextureWithIndex:(int)index{
    //return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"player1-n%d.png",index]];
    return [[[self class] shared] textureNamed:[NSString stringWithFormat:@"bird%d.png",index]];
}

+(SKTexture *)dropBird
{
    return [[[self class] shared] textureNamed:@"bird5.png"];
}

+ (SKAction *)playerAction
{
    NSMutableArray *textures = [[NSMutableArray alloc]init];
    
    for (int i= 1; i<=2; i++) {
        SKTexture *texture = [[self class] playerTextureWithIndex:i];
        
        [textures addObject:texture];
        //[textures addObject:[SKAction waitForDuration:0.02]];
    }
    return [SKAction repeatActionForever:[SKAction animateWithTextures:textures timePerFrame:0.1f]];
}
@end
