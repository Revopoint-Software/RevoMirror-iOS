//
//  RMI_NoCameraView.m
//  RevoScan_iOS
//
//  Created by 邓亮 on 2023/8/24.
//

#import "RMI_NoWifiView.h"

@interface RMI_NoWifiView ()

@end

@implementation RMI_NoWifiView

-(instancetype)init
{
    self = [super init];
    if(self){
        [self createUI];
    }
    return self;
}

-(void)createUI
{
    UIFont *font = [UIFont systemFontOfSize:14.0];
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.backgroundColor = UIColorFromRGBA(0xFFFFFF,0.1);
    settingBtn.layer.cornerRadius = 16.0;
    settingBtn.titleLabel.numberOfLines = 0;
    settingBtn.layer.borderWidth = 1.0;
    settingBtn.layer.borderColor = UIColorFromRGB(0xA3A2A3).CGColor;
    [settingBtn setTitle:RMI_MirrorStr_Setting() forState:(UIControlStateNormal)];
    settingBtn.titleLabel.font = font;
    [settingBtn addTarget:self action:@selector(settingAction) forControlEvents:UIControlEventTouchUpInside];
    settingBtn.clipsToBounds = YES;
    [self addSubview:settingBtn];
    CGSize size = [RMI_MirrorStr_Setting() sizeWithAttributes:@{NSFontAttributeName:font}];
    float width = size.width+32;
    [settingBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-20);
        make.top.mas_equalTo(self).offset(14);
        make.width.equalTo(@(width));
        make.height.equalTo(@32);
    }];
    
    UIImageView *imgView = [UIImageView new];
    imgView.image = [UIImage imageNamed:@"RMI_Connect_Wifi"];
    [self addSubview:imgView];
    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(-55);
        make.centerX.mas_equalTo(self);
        make.width.equalTo(@676);
        make.height.equalTo(@144);
    }];
    
    UILabel *connectLabel = [UILabel new];
    connectLabel.text = RMI_MirrorStr_NetNoConnect();
    connectLabel.font = [UIFont systemFontOfSize:20.0 weight:UIFontWeightMedium];
    connectLabel.textColor = UIColorFromRGB(0xFF8225);
    [self addSubview:connectLabel];
    [connectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imgView.mas_bottom).offset(24);
        make.centerX.mas_equalTo(self).offset(-10);
    }];
    
    UIImageView *connectImgView = [UIImageView new];
    connectImgView.image = [UIImage imageNamed:@"RMI_Connect_More"];
    [self addSubview:connectImgView];
    [connectImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(connectLabel.mas_right).offset(8);
        make.centerY.mas_equalTo(connectLabel);
        make.width.height.equalTo(@24);
    }];
    
    _connView = [UIView new];
    _connView.userInteractionEnabled = YES;
    [self addSubview:_connView];
    [_connView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(connectLabel).offset(-10);
        make.left.mas_equalTo(connectLabel).offset(-10);
        make.right.mas_equalTo(connectImgView).offset(10);
        make.bottom.mas_equalTo(connectLabel).offset(10);
    }];
    UITapGestureRecognizer *setTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAppSet)];
    [_connView addGestureRecognizer:setTap];
    
    UILabel *infoLabel = [UILabel new];
    infoLabel.text = RMI_MirrorStr_NetConnectTip();
    infoLabel.font = [UIFont systemFontOfSize:14.0 weight:UIFontWeightMedium];
    infoLabel.textAlignment = NSTextAlignmentCenter;
    infoLabel.textColor = UIColorFromRGB(0xCCCCCC);
    infoLabel.preferredMaxLayoutWidth = 676;
    infoLabel.numberOfLines = 0;
    infoLabel.userInteractionEnabled = YES;
    [self addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.top.mas_equalTo(connectImgView.mas_bottom).offset(15);
    }];
    
    [self ts_RMI_ChangeLanguage:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            connectLabel.text = RMI_MirrorStr_NetNoConnect();
            infoLabel.text = RMI_MirrorStr_NetConnectTip();
            
            [settingBtn setTitle:RMI_MirrorStr_Setting() forState:(UIControlStateNormal)];
            CGSize size = [RMI_MirrorStr_Setting() sizeWithAttributes:@{NSFontAttributeName:font}];
            float width = size.width+32;
            [settingBtn mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(@(width));
            }];
        });
    }];
}

//wifi设置
-(void)toAppSet
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"App-Prefs:root=WIFI"] options:@{} completionHandler:^(BOOL success) {
        
    }];
}

-(void)settingAction
{
    if (self.toSettingVC) {
        self.toSettingVC();
    }
}

@end
