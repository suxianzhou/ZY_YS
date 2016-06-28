//
//  RWMainViewController+Drawer.h
//  ZhongYuSubjectHubKY
//
//  Created by zhongyu on 16/5/23.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import "RWMainViewController.h"

@interface RWMainViewController (Drawer)

<
    RWDrawerViewDelegate
>

- (void)compositionDrawer;

- (void)drawerSwitch;

- (void)openDrawer;

- (void)closeDrawer;

@end
