//
//  UIComputerView.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/22/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RMI_TemporaryHost.h"

@protocol HostCallback <NSObject>

- (void) hostClicked:(RMI_TemporaryHost*)host view:(UIView*)view;
- (void) hostLongClicked:(RMI_TemporaryHost*)host view:(UIView*)view;
- (void) addHostClicked;

@end

@interface UIComputerView : UIButton <UIContextMenuInteractionDelegate>

- (id) initWithComputer:(RMI_TemporaryHost*)host andCallback:(id<HostCallback>)callback;
- (id) initForAddWithCallback:(id<HostCallback>)callback;

@end
