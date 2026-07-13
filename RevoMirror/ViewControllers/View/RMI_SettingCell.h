//
//  RMI_ScanSettingCell.h
//  RevoScan_iOS
//
//  Created by 邓亮 on 2022/11/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//扫描设置cell
@interface RMI_SettingCell : UITableViewCell

-(void)updateCellString:(NSString *)titleString subString:(NSString *)subString selectBlue:(BOOL)selectBlue needCheck:(BOOL)needCheck;

@end

NS_ASSUME_NONNULL_END
