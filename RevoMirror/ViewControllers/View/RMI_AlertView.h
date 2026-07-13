//
//  RMI_AlertView.h
//  Revo Mirror
//
//  Created by 邓亮 on 2025/8/21.
//  Copyright © 2025 RevoMirror Project. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClickBlock)(NSInteger tag);

NS_ASSUME_NONNULL_BEGIN

@interface RMI_AlertView : UIView

+ (RMI_AlertView *)sharedAlertView;

//普通弹出框
+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle clickBlock:(ClickBlock)block;

//带输入框弹出框
+ (void)showInputAlertWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle clickBlock:(ClickBlock)block;

+ (void)dismissAlert;

@end

NS_ASSUME_NONNULL_END
