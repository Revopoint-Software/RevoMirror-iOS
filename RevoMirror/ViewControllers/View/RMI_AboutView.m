//
//  RMI_AboutView.m
//  RevoScan_iOS
//
//  Created by 邓亮 on 2022/11/24.
//

#import "RMI_AboutView.h"
#import "RMI_GuideVC.h"

@implementation RMI_AboutView

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
    UILabel *nameLabel = [UILabel new];
    nameLabel.text = @"Revo Mirror";
    nameLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
    nameLabel.textColor = [UIColor whiteColor];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self).offset(-5);
        make.left.right.mas_equalTo(self);
    }];
    
    UIImageView *logoImgView = [UIImageView new];
    logoImgView.image = [UIImage imageNamed:@"RMI_About_Logo"];
    [self addSubview:logoImgView];
    [logoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self);
        make.width.height.equalTo(@80);
        make.bottom.mas_equalTo(nameLabel.mas_top).offset(-12);
    }];
    
    UILabel *versionLabel = [UILabel new];
    versionLabel.text = [NSString stringWithFormat:@"V %@",[UIDevice appCurVersion]];
    versionLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
    versionLabel.textColor = UIColorFromRGB(0xA6A6A6);
    versionLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:versionLabel];
    [versionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(nameLabel.mas_bottom).offset(6);
        make.left.right.mas_equalTo(self);
    }];
    
    UILabel *policyLabel = [UILabel new];
    policyLabel.text = RMI_MirrorStr_PrivatePolicy();
    policyLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    policyLabel.textColor = UIColorFromRGB(0xE64545);
    policyLabel.userInteractionEnabled = YES;
    [self addSubview:policyLabel];
    [policyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(versionLabel.mas_bottom).offset(28);
        make.centerX.mas_equalTo(self).offset(0);
    }];
    UITapGestureRecognizer *policyGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toPrivacy)];
    [policyLabel addGestureRecognizer:policyGester];
    
    UIView *leftLineView = [UIView new];
    leftLineView.backgroundColor = UIColorFromRGB(0xC0C0C0);
    [self addSubview:leftLineView];
    [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(policyLabel.mas_left).offset(-12).priorityHigh();
        make.centerY.mas_equalTo(policyLabel);
        make.width.equalTo(@1);
        make.height.equalTo(@12);
    }];
    
    UILabel *agreementLabel = [UILabel new];
    agreementLabel.text = RMI_MirrorStr_UserPolicy();
    agreementLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    agreementLabel.textColor = UIColorFromRGB(0xE64545);
    agreementLabel.userInteractionEnabled = YES;
    agreementLabel.numberOfLines = 0;
    agreementLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:agreementLabel];
    [agreementLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(leftLineView);
        make.right.mas_equalTo(leftLineView.mas_left).offset(-12);
        make.left.mas_equalTo(self).offset(5);
    }];
    UITapGestureRecognizer *agreeGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toAgreement)];
    [agreementLabel addGestureRecognizer:agreeGester];
    
    UIView *rightLineView = [UIView new];
    rightLineView.backgroundColor = UIColorFromRGB(0xC0C0C0);
    [self addSubview:rightLineView];
    [rightLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(policyLabel.mas_right).offset(12).priorityHigh();
        make.centerY.mas_equalTo(policyLabel);
        make.width.equalTo(@1);
        make.height.equalTo(@12);
    }];
    
    UILabel *gplvLabel = [UILabel new];
    gplvLabel.text = RMI_MirrorStr_Gplv3();
    gplvLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
    gplvLabel.textColor = UIColorFromRGB(0xE64545);
    gplvLabel.userInteractionEnabled = YES;
    gplvLabel.numberOfLines = 0;
    gplvLabel.textAlignment = NSTextAlignmentLeft;
    [self addSubview:gplvLabel];
    [gplvLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(rightLineView.mas_right).offset(12);
        make.centerY.mas_equalTo(rightLineView);
        make.right.mas_equalTo(self).offset(-5);
    }];
    UITapGestureRecognizer *gplvGester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toGplv)];
    [gplvLabel addGestureRecognizer:gplvGester];
    
    UILabel *copyRightLabel = [UILabel new];
    copyRightLabel.text = @"Copyright Ⓒ 2025.All right reserved.";
    copyRightLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    copyRightLabel.textColor = UIColorFromRGB(0xA6A6A6);
    copyRightLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:copyRightLabel];
    [copyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(policyLabel.mas_bottom).offset(12);
        make.left.right.mas_equalTo(self);
    }];
    
    UILabel *techLabel = [UILabel new];
    techLabel.text = @"Revopiont 3D Technologies Inc.";
    techLabel.font = [UIFont systemFontOfSize:12 weight:UIFontWeightRegular];
    techLabel.textColor = UIColorFromRGB(0xA6A6A6);
    techLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:techLabel];
    [techLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(copyRightLabel.mas_bottom).offset(0);
        make.left.right.mas_equalTo(self);
    }];
    
    [self ts_RMI_ChangeLanguage:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            policyLabel.text = RMI_MirrorStr_PrivatePolicy();
            agreementLabel.text = RMI_MirrorStr_UserPolicy();
            gplvLabel.text = RMI_MirrorStr_Gplv3();
        });
    }];
}

-(void)toAgreement
{
    NSLog(@"to agreement");
    RMI_GuideVC *guideVC = [[RMI_GuideVC alloc] init];
    guideVC.type = RMI_GuideVC_Agrement;
    [[RMI_Tools currentNavigation] pushViewController:guideVC animated:YES];
}

-(void)toPrivacy
{
    NSLog(@"to privacy");
    RMI_GuideVC *guideVC = [[RMI_GuideVC alloc] init];
    guideVC.type = RMI_GuideVC_Policy;
    [[RMI_Tools currentNavigation] pushViewController:guideVC animated:YES];
}

-(void)toGplv
{
    NSLog(@"to Gplv3");
    RMI_GuideVC *guideVC = [[RMI_GuideVC alloc] init];
    guideVC.type = RMI_GuideVC_GPLV3;
    [[RMI_Tools currentNavigation] pushViewController:guideVC animated:YES];
}

@end
