//
//  ZLSettingView.m
//  SpriteKit
//
//  Created by libs on 14-3-26.
//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import "ZLSettingView.h"
#import "SKAppDelegate.h"

@interface ZLSettingView()


@end

@implementation ZLSettingView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initBackground];
        
        [self createButtons];
        //[self initResumeButton];
        //[self initVoiceMusic];
    }
    return self;
}

-(void)initBackground
{
    self.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"alpha.png"]];
    
   
//    self.backgroundColor=[UIColor blackColor];
//    self.alpha=0.5;
    /*
    UIImageView *bgView=[[UIImageView alloc] initWithFrame:self.bounds];
    bgView.image=[UIImage imageNamed:@"setting_bg"];
    [self addSubview:bgView];
    */
    /*
    UILabel *lblTitle=[[UILabel alloc] initWithFrame:CGRectMake(85, 15, self.frame.size.width-170, 40)];
    lblTitle.text=@"Setting";
    lblTitle.textColor=[UIColor whiteColor];
    lblTitle.textAlignment=NSTextAlignmentCenter;
    lblTitle.font=[UIFont fontWithName:@"ChalkboardSE-Bold" size:24];
    [self addSubview:lblTitle];
     */
}

-(void)createButtons
{
    float buttonWidth=60;
    
    UIImageView *lineView=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"line.png"]];
    [self addSubview:lineView];
    lineView.frame=CGRectMake(buttonWidth*3, 0, 1, buttonWidth);
    
    /*
    UIImageView *imvVoiceBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_bg"]];
    imvVoiceBG.frame=CGRectMake(0, 0, buttonWidth, buttonWidth);
    [self addSubview:imvVoiceBG];
    
    UIImageView *imvMusicBG=[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"btn_bg"]];
    imvMusicBG.frame=CGRectMake(buttonWidth, 0, buttonWidth, buttonWidth);
    [self addSubview:imvMusicBG];
    
    */
    mBtnVoice=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *voiceImage=[UIImage imageNamed:@"voice.png"];
    [mBtnVoice setBackgroundImage:voiceImage forState:UIControlStateNormal];
    [mBtnVoice setImage:[UIImage imageNamed:@"unused"] forState:UIControlStateSelected];
    mBtnVoice.frame=CGRectMake((buttonWidth-voiceImage.size.width)/2, (buttonWidth-voiceImage.size.height)/2, voiceImage.size.width, voiceImage.size.height);
    [mBtnVoice addTarget:self action:@selector(onChangeVoiceState) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mBtnVoice];
    [mBtnVoice setSelected:![ZLHistoryManager voiceOpened]];
    
    
    mBtnMusic=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *musicImage=[UIImage imageNamed:@"music.png"];
    [mBtnMusic setBackgroundImage:musicImage forState:UIControlStateNormal];
    [mBtnMusic setImage:[UIImage imageNamed:@"unused"] forState:UIControlStateSelected];
    mBtnMusic.frame=CGRectMake(buttonWidth+(buttonWidth-musicImage.size.width)/2, (buttonWidth-musicImage.size.height)/2, musicImage.size.width, musicImage.size.height);
    [mBtnMusic addTarget:self action:@selector(onChangeMusicState) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mBtnMusic];
    [mBtnMusic setSelected:![ZLHistoryManager musicOpened]];
    
    mBtnRestart=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *restartImage=[UIImage imageNamed:@"restart.png"];
    [mBtnRestart setImage:restartImage forState:UIControlStateNormal];
    mBtnRestart.frame=CGRectMake(buttonWidth*2+(buttonWidth-restartImage.size.width)/2, (buttonWidth-restartImage.size.height)/2, restartImage.size.width, restartImage.size.height);
    [mBtnRestart addTarget:self action:@selector(onTapRestart) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mBtnRestart];
   // [mBtnRestart setSelected:![ZLHistoryManager musicOpened]];
    
    mBtnClose=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *closeImage=[UIImage imageNamed:@"close.png"];
    [mBtnClose setImage:closeImage forState:UIControlStateNormal];
    mBtnClose.frame=CGRectMake(buttonWidth*3+(buttonWidth-closeImage.size.width)/2, (buttonWidth-closeImage.size.height)/2, closeImage.size.width, closeImage.size.height);
    [mBtnClose addTarget:self action:@selector(onTapClose) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:mBtnClose];
    
}

-(void)onChangeVoiceState
{
    BOOL open=[ZLHistoryManager voiceOpened];
    [ZLHistoryManager setVoiceOpened:!open];
    [mBtnVoice setSelected:open];
}

-(void)onChangeMusicState
{
    BOOL open=[ZLHistoryManager musicOpened];
    [ZLHistoryManager setMusicOpened:!open];
    [mBtnMusic setSelected:open];
    if ([ZLHistoryManager musicOpened]) {
        [(SKAppDelegate *)([UIApplication sharedApplication].delegate) startBGAudio];
    }else{
        [(SKAppDelegate *)([UIApplication sharedApplication].delegate) stopBGAudio];
    }
}

-(void)onTapClose
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onSettingViewClose:)]) {
        [self.delegate onSettingViewClose:self];
    }
}


-(void)onTapRestart
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(onSettingViewRestart:)]) {
        [self.delegate onSettingViewRestart:self];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
