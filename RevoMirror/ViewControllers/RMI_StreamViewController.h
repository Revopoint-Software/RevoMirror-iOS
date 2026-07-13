//
//  RMI_StreamViewController.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/18/14.
//  Copyright (c) 2015 RevoMirror. All rights reserved.
//

#import "Connection.h"
#import "RMI_StreamConfiguration.h"
#import "StreamView.h"

#import <UIKit/UIKit.h>

@interface RMI_StreamViewController : UIViewController <ConnectionCallbacks, ControllerSupportDelegate, UserInteractionDelegate, UIScrollViewDelegate>

@property (nonatomic) RMI_StreamConfiguration* streamConfig;
-(void)updatePreferredDisplayMode:(BOOL)streamActive;

@end
