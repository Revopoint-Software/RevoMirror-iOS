//
//  RMI_NoCameraView.h
//  RevoScan_iOS
//
//  Created by 邓亮 on 2023/8/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface RMI_NoWifiView : UIView

@property(nonatomic,strong)UIView *connView;

@property(nonatomic,copy)void(^toSettingVC)(void);

@end

NS_ASSUME_NONNULL_END
