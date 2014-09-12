//
//  SKViewController.h
//  SpriteKit
//

//  Copyright (c) 2014年 CpSoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SpriteKit/SpriteKit.h>
#import "ZLSettingView.h"

@interface SKViewController : UIViewController<ZLSettingViewDelegate>
{
    BOOL    bSettingShowing;
    UIButton *btnSetting;
}
@end
