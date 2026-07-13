//
//  RMI_ActionSheetView.m
//  Revo Mirror
//
//  Created by 邓亮 on 2025/8/19.
//  Copyright © 2025 RevoMirror Project. All rights reserved.
//

#import "RMI_ActionSheetView.h"
#import "RMI_Tools.h"

@interface RMI_ActionSheetView ()

@property (nonatomic, copy) void(^clickBlock)(int index);
@property (nonatomic, strong) UIView *alView;

@end

@implementation RMI_ActionSheetView

+(void)showActionSheetWithAlertList:(NSArray *)alertArray cancelTitle:(NSString *)cancelTitle block:(void(^)(int index))block
{
    UIView *window = [RMI_Tools keyWindow];
    RMI_ActionSheetView *pView = [[RMI_ActionSheetView alloc] initWithFrame:CGRectMake(0, 0, RMI_IPHONE_WIDTH, RMI_IPHONE_HEIGHT)];
    pView.userInteractionEnabled = YES;
    [pView showActionSheetWithAlertList:alertArray cancelTitle:cancelTitle block:block];
    [window addSubview:pView];
}

-(void)showActionSheetWithAlertList:(NSArray *)alertArray cancelTitle:(NSString *)cancelTitle block:(void(^)(int index))block
{
    self.clickBlock = block;
    
    UITapGestureRecognizer *gest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeSelf)];
    [self addGestureRecognizer:gest];
    
    UIView *view = [UIView new];
    view.backgroundColor = UIColorFromRGBA(0x000000,0.6);
    [self addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(self);
    }];
    
    float alViewHeight = alertArray.count*60+60+20+10;
    _alView = [UIView new];
    _alView.frame = CGRectMake((RMI_IPHONE_WIDTH-377)/2.0, RMI_IPHONE_HEIGHT, 377, alViewHeight);
    [self addSubview:_alView];
    
    for (int x=0; x<alertArray.count+1; x++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = UIColorFromRGB(0x303030);
        btn.layer.cornerRadius = 12.0;
        btn.clipsToBounds = YES;
        btn.titleLabel.font = [UIFont systemFontOfSize:20.0 weight:(UIFontWeightMedium)];
        if (x == alertArray.count) {
            btn.frame = CGRectMake(0, x*60+10, 377, 60);
            [btn setTitle:cancelTitle forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
            btn.tag = 0;
        }else{
            btn.frame = CGRectMake(0, x*60, 377, 60);
            [btn setTitle:alertArray[x] forState:UIControlStateNormal];
            [btn setTitleColor:UIColorFromRGB(0xE64545) forState:UIControlStateNormal];
            btn.tag = x+1;
        }
        [btn addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [_alView addSubview:btn];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alView.frame = CGRectMake((RMI_IPHONE_WIDTH-377)/2.0, RMI_IPHONE_HEIGHT-alViewHeight, 377, alViewHeight);
    }];
}

-(void)btnAction:(UIButton *)sender
{
    [self removeSelf];
    if (self.clickBlock) {
        self.clickBlock((int)sender.tag);
    }
}

//点击周边区域 移除
-(void)removeSelf
{
    [UIView animateWithDuration:0.3 animations:^{
        self.alView.frame = CGRectMake((RMI_IPHONE_WIDTH-377)/2.0, RMI_IPHONE_HEIGHT, 377, self.alView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

@end
