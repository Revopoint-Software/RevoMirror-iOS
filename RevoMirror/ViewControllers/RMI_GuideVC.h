//
//  RMI_GuideVC.h
//  RevoScan_iOS
//
//  Created by 邓亮 on 2023/2/4.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RMI_GuideVC_Agrement,
    RMI_GuideVC_Policy,
    RMI_GuideVC_GPLV3
} RMI_GuideVC_Type;

NS_ASSUME_NONNULL_BEGIN

@interface RMI_GuideVC : UIViewController

@property(nonatomic,assign)RMI_GuideVC_Type type;

@end

NS_ASSUME_NONNULL_END
