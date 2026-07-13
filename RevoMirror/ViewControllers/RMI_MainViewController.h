//
//  RMI_MainViewController.h
//  Revo Mirror
//
//  Created by Diego Waxemberg on 1/17/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoveryManager.h"
#import "PairManager.h"
#import "RMI_StreamConfiguration.h"
#import "UIComputerView.h"
#import "AppAssetManager.h"

@interface RMI_MainViewController : UIViewController <DiscoveryCallback, PairCallback, HostCallback, AppAssetCallback, NSURLConnectionDelegate>

@end
