//
//  ZLSettingView.h
//  SpriteKit
//
//  Created by libs on 14-3-26.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSIconButton.h"
#import "ZLHistoryManager.h"

@protocol ZLSettingViewDelegate;
@interface ZLSettingView : UIView
{
    UIButton        *mBtnVoice;
    UIButton        *mBtnMusic;
    UIButton        *mBtnRestart;
    UIButton        *mBtnClose;
}

@property(nonatomic,assign)id<ZLSettingViewDelegate> delegate;
@end

@protocol ZLSettingViewDelegate <NSObject>


-(void)onSettingViewRestart:(ZLSettingView *)view;

-(void)onSettingViewClose:(ZLSettingView *)view;


@end