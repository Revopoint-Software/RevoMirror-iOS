//
//  RMI_ActionSheetView.h
//  Revo Mirror
//
//  Created by 邓亮 on 2025/8/19.
//  Copyright © 2025 RevoMirror Project. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RMI_ActionSheetView : UIView

+(void)showActionSheetWithAlertList:(NSArray *)alertArray cancelTitle:(NSString *)cancelTitle block:(void(^)(int index))block;

@end

NS_ASSUME_NONNULL_END
