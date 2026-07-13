//
//  RMI_AlertView.m
//  Revo Mirror
//
//  Created by 邓亮 on 2025/8/21.
//  Copyright © 2025 RevoMirror Project. All rights reserved.
//

#import "RMI_AlertView.h"

#define Min_Left_Space 16
#define Min_Top_Space 20
#define Min_Content_Space 10

#define ButtonHeight 48
#define ButtonWidth ContainWidth/2
#define ContainWidth 270

#define P_ContainWidth 230

@interface RMI_AlertView ()<UITextFieldDelegate>
@property (nonatomic ,strong) UIView *bgView;
@property (nonatomic ,strong) UIView *containView;
@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *contentLabel;
@property (nonatomic ,strong) UIView *contentInputView;
@property (nonatomic ,strong) UITextField *contentInputField;

@property (nonatomic ,strong) UIButton *cancelButton;
@property (nonatomic ,strong) UIButton *otherButton;
@property (nonatomic ,strong) UIView *btnLineView;//横线
@property (nonatomic ,strong) UIView *btnHorizontalLineView;
@property (nonatomic ,strong) UIView *btnHLineView;//竖线
@property (nonatomic ,copy) ClickBlock clickBlock;

@property (nonatomic ,strong) UITapGestureRecognizer *containTap;
@property (nonatomic ,strong) UITapGestureRecognizer *bgTap;

@end

@implementation RMI_AlertView

static RMI_AlertView *_instance = nil;

+ (RMI_AlertView *)sharedAlertView
{
    if(!_instance) {
        return [[self alloc] init];
    }else {
        return _instance;
    }
}

+ (id)allocWithZone:(NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

+(void)createUI
{
    _instance = [RMI_AlertView sharedAlertView];
    _instance.frame = [RMI_Tools keyWindow].bounds;
    _instance.bgView.hidden = NO;
    _instance.containView.hidden = NO;
    [_instance.containView removeGestureRecognizer:_instance.containTap];
    [_instance.bgView removeGestureRecognizer:_instance.bgTap];
}

+ (void)showAlertWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle clickBlock:(ClickBlock)block
{
    [self showCommonAlertWithFrame:CGRectNull image:nil title:title content:message needField:NO textAlignment:NSTextAlignmentCenter isFrameAlert:NO progressHidden:YES lineSpace:2 isHorizontal:YES cancelTitle:cancelTitle otherTitle:otherTitle clickBlock:block];
}

+ (void)showInputAlertWithTitle:(NSString *)title Message:(NSString *)message cancelTitle:(NSString *)cancelTitle otherTitle:(NSString *)otherTitle clickBlock:(ClickBlock)block
{
    [self showCommonAlertWithFrame:CGRectNull image:nil title:title content:message needField:YES textAlignment:NSTextAlignmentCenter isFrameAlert:NO progressHidden:YES lineSpace:2 isHorizontal:YES cancelTitle:cancelTitle otherTitle:otherTitle clickBlock:block];
}

+ (void)showCommonAlertWithFrame:(CGRect)frame
                           image:(UIImage *)image
                           title:(nullable NSString *)title
                         content:(nullable NSString *)content
                       needField:(BOOL)needField
                   textAlignment:(NSTextAlignment)textAlignment
                    isFrameAlert:(BOOL)isFrameAlert
                  progressHidden:(BOOL)progressHidden
                       lineSpace:(CGFloat)lineSpace
                    isHorizontal:(BOOL)isHorizontal
                     cancelTitle:(nullable NSString *)cancelTitle
                      otherTitle:(nullable NSString *)otherTitle
                      clickBlock:(ClickBlock)block
{
    
    [self createUI];
    [RMI_AlertView ShakeAnimationWithView:_instance.containView];
    
    _instance.containView.backgroundColor = UIColorFromRGBA(0x272727, 1.0);
    
    _instance.clickBlock = block;
    CGFloat containW = ContainWidth;
    if (frame.size.width > 0) {
        containW = frame.size.width;
    }
    _instance.containView.frame = CGRectMake((RMI_IPHONE_WIDTH - containW)/2, _instance.containView.frame.origin.y, containW, _instance.containView.frame.size.height);
    
    CGFloat titleSpace = title.length > 0?Min_Top_Space:0;
    _instance.titleLabel.text = title;
    [_instance.titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_instance.containView).offset(titleSpace);
        make.centerX.mas_equalTo(_instance.containView.mas_centerX);
        make.left.mas_equalTo(_instance.containView.mas_left).offset(Min_Left_Space);
        make.right.mas_equalTo(_instance.containView.mas_right).offset(-Min_Left_Space);
    }];
    
    if(isFrameAlert){
//        _instance.titleLabel.textAlignment = NSTextAlignmentCenter;
        _instance.titleLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightMedium];
        _instance.contentLabel.textColor = UIColorFromRGB(0xCCCCCC);
        _instance.contentLabel.font = [UIFont systemFontOfSize:14 weight:UIFontWeightRegular];
        _instance.contentLabel.textAlignment = NSTextAlignmentCenter;
    }else{
//        _instance.titleLabel.textAlignment = NSTextAlignmentCenter;
        _instance.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _instance.contentLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _instance.contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _instance.contentLabel.textAlignment = textAlignment;
    }
    NSString *lineSpaceString;
    if (lineSpace > 0) {
        lineSpaceString = [NSString stringWithFormat:@"%.2f",lineSpace];
    }
    NSMutableAttributedString *attrDescribeStr;
    
    NSInteger contentLength = 0 ;
    if ([content isKindOfClass:[NSAttributedString class]]) {
        NSAttributedString *contentStr = (NSAttributedString *)content;
        
        attrDescribeStr = [[NSMutableAttributedString alloc]initWithAttributedString:contentStr];
        contentLength = contentStr.length;
        
    }else {
        NSString *contentStr = (NSString *)content;
        contentLength = contentStr.length;
        attrDescribeStr = [[NSMutableAttributedString alloc]initWithString:contentStr];
    }
    
    if (lineSpaceString) {
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        [paraStyle setLineSpacing:[lineSpaceString floatValue]];
        paraStyle.alignment = isFrameAlert?NSTextAlignmentCenter:textAlignment;
        [attrDescribeStr addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, contentLength)];
    }
    
    _instance.contentLabel.attributedText = attrDescribeStr;
    CGFloat contentSpace = title.length>0?Min_Content_Space:0;
    [_instance.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        if (textAlignment != NSTextAlignmentCenter) {
            make.top.mas_equalTo(_instance.titleLabel.mas_bottom).offset(contentSpace);
            make.left.mas_equalTo(_instance.containView.mas_left).offset(Min_Left_Space);
            make.right.mas_equalTo(_instance.containView.mas_right).offset(-Min_Left_Space);
            if (cancelTitle.length == 0 && otherTitle.length == 0 && progressHidden) {
                make.bottom.mas_equalTo(_instance.containView).offset(-Min_Top_Space);
            }
        }else{
            
            make.top.mas_equalTo(_instance.titleLabel.mas_bottom).offset(contentSpace);
            make.left.mas_equalTo(_instance.containView.mas_left).offset(Min_Left_Space);
            make.right.mas_equalTo(_instance.containView.mas_right).offset(-Min_Left_Space);
            if (cancelTitle.length == 0 && otherTitle.length == 0 && progressHidden) {
                make.bottom.mas_equalTo(_instance.containView).offset(-Min_Top_Space);
            }
        }
    }];
    
    if(needField){
        _instance.contentInputView.hidden = NO;
        _instance.contentInputField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(0x8C8C8C)}];
    }else{
        _instance.contentInputView.hidden = YES;
    }
    
    _instance.btnLineView.hidden = YES;
    _instance.btnHLineView.hidden = YES;
    _instance.btnHorizontalLineView.hidden = YES;
    
    [_instance.otherButton setImage:nil forState:(UIControlStateNormal)];
    [_instance.otherButton setTitleEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    [_instance.otherButton setImageEdgeInsets:(UIEdgeInsetsMake(0, 0, 0, 0))];
    
    CGFloat btnSpace = content.length>0?Min_Top_Space:0;
    if (cancelTitle.length > 0 || otherTitle.length > 0) {
        _instance.cancelButton.hidden = NO;
        _instance.otherButton.hidden = NO;
        _instance.btnLineView.hidden = NO;
        if (cancelTitle.length > 0 && otherTitle.length >0) {
            [_instance.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            [_instance.otherButton setTitle:otherTitle forState:UIControlStateNormal];
            [_instance.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ButtonWidth);
                make.height.mas_equalTo(ButtonHeight);
                make.top.mas_equalTo(needField?_instance.contentInputView.mas_bottom:_instance.contentLabel.mas_bottom).offset(needField?18:btnSpace);
                make.left.mas_equalTo(_instance.containView.mas_left).offset(0);
            }];
            [_instance.otherButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(ButtonWidth);
                make.height.mas_equalTo(ButtonHeight);
                make.top.mas_equalTo(needField?_instance.contentInputView.mas_bottom:_instance.contentLabel.mas_bottom).offset(needField?18:btnSpace);
                make.right.mas_equalTo(_instance.containView.mas_right).offset(0);
                make.bottom.mas_equalTo(_instance.containView.mas_bottom).offset(0);
            }];
            [_instance.btnLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_instance.cancelButton.mas_top).offset(-1);
                make.left.mas_equalTo(_instance.containView).offset(0);
                make.right.mas_equalTo(_instance.containView).offset(0);
                make.height.equalTo(@0.5);
            }];
            _instance.btnHLineView.hidden = NO;
            [_instance.btnHLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_instance.btnLineView.mas_bottom).offset(0);
                make.centerX.mas_equalTo(_instance.containView).offset(0);
                make.width.equalTo(@0.5);
                make.bottom.mas_equalTo(_instance.cancelButton).offset(0);
            }];
        }else if (cancelTitle.length >0){
            _instance.otherButton.hidden = YES;
            [_instance.cancelButton setTitle:cancelTitle forState:UIControlStateNormal];
            [_instance.cancelButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ButtonHeight);
                make.top.mas_equalTo(needField?_instance.contentInputView.mas_bottom:_instance.contentLabel.mas_bottom).offset(needField?18:btnSpace);
                make.left.mas_equalTo(_instance.containView).offset(0);
                make.right.mas_equalTo(_instance.containView).offset(0);
                make.bottom.mas_equalTo(_instance.containView.mas_bottom).offset(0);
            }];
            [_instance.btnLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_instance.cancelButton.mas_top).offset(-1);
                make.left.mas_equalTo(_instance.containView).offset(0);
                make.right.mas_equalTo(_instance.containView).offset(0);
                make.height.equalTo(@0.5);
            }];
        }else if (otherTitle.length > 0) {
            _instance.cancelButton.hidden = YES;
            [_instance.otherButton setTitle:otherTitle forState:UIControlStateNormal];
            [_instance.otherButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(ButtonHeight);
                make.top.mas_equalTo(needField?_instance.contentInputView.mas_bottom:_instance.contentLabel.mas_bottom).offset(needField?18:btnSpace);
                make.left.mas_equalTo(_instance.containView).offset(0);
                make.right.mas_equalTo(_instance.containView).offset(0);
                make.bottom.mas_equalTo(_instance.containView.mas_bottom).offset(0);
            }];
            [_instance.btnLineView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(_instance.otherButton.mas_top).offset(-1);
                make.left.mas_equalTo(_instance.containView).offset(0);
                make.right.mas_equalTo(_instance.containView).offset(0);
                make.height.equalTo(@0.5);
            }];
        }
    }
    else
    {
        _instance.cancelButton.hidden = YES;
        _instance.otherButton.hidden = YES;
    }
        
    if (cancelTitle) {
        [_instance.cancelButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
    }
    if (otherTitle) {
        [_instance.otherButton setTitleColor:UIColorFromRGB(0xE64545) forState:UIControlStateNormal];
    }else{
        [_instance.cancelButton setTitleColor:UIColorFromRGB(0xE64545) forState:UIControlStateNormal];
    }
    
    [_instance.containView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(containW);
        make.center.equalTo(_instance);
    }];
    _instance.containView.layer.cornerRadius = 8;
    _instance.containView.clipsToBounds = YES;
    [[RMI_Tools keyWindow] addSubview:_instance];
    [UIView animateWithDuration:0.35 animations:^{
        _instance.containView.alpha = 1;
    }];
}

+(void)ShakeAnimationWithView:(UIView *)view
{
    CAKeyframeAnimation *popAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    popAnimation.duration = 0.4;
    popAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.01f, 0.01f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1f, 1.1f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.9f, 0.9f, 1.0f)],
                            [NSValue valueWithCATransform3D:CATransform3DIdentity]];
    popAnimation.keyTimes = @[@0.0f, @0.5f, @0.75f, @1.0f];
    popAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut],
                                     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [view.layer addAnimation:popAnimation forKey:nil];
}

+ (void)dismissAlert
{
    [_instance removeFromSuperview];
}

- (void)handleOther
{
    if(_instance.contentInputField){
        __renameString = _instance.contentInputField.text;
    }
    [RMI_AlertView dismissAlert];
    if (self.clickBlock) {
        self.clickBlock(1);
    }
}

- (void)handleCancel
{
    [RMI_AlertView dismissAlert];
    if (self.clickBlock) {
        self.clickBlock(0);
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _instance.bounds = CGRectMake(0.0f, 110, _instance.bounds.size.width, _instance.bounds.size.height);
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
    _instance.bounds = CGRectMake(0.0f, 0, _instance.bounds.size.width, _instance.bounds.size.height);
    return YES;
}

#pragma mark - 懒加载
- (UIButton *)otherButton
{
    if (!_otherButton) {
        _otherButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_otherButton addTarget:self action:@selector(handleOther) forControlEvents:UIControlEventTouchUpInside];
        _otherButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        [_otherButton setTitleColor:UIColorFromRGB(0xE64545) forState:UIControlStateNormal];
        _otherButton.titleLabel.numberOfLines = 0;
        _otherButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.containView addSubview:_otherButton];
    }
    return _otherButton;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self action:@selector(handleCancel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton setTitleColor:UIColorFromRGB(0xFFFFFF) forState:UIControlStateNormal];
        _cancelButton.backgroundColor = [UIColor clearColor];
        _cancelButton.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightRegular];
        _cancelButton.titleLabel.numberOfLines = 0;
        _cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;

        [self.containView addSubview:_cancelButton];
    }
    return _cancelButton;
}

-(UIView *)btnLineView
{
    if(!_btnLineView){
        _btnLineView = [UIView new];
        _btnLineView.backgroundColor = UIColorFromRGB(0x555555);
        [self.containView addSubview:_btnLineView];
    }
    return _btnLineView;
}

-(UIView *)btnHorizontalLineView
{
    if(!_btnHorizontalLineView){
        _btnHorizontalLineView = [UIView new];
        _btnHorizontalLineView.backgroundColor = UIColorFromRGB(0x555555);
        [self.containView addSubview:_btnHorizontalLineView];
    }
    return _btnHorizontalLineView;
}

-(UIView *)btnHLineView
{
    if(!_btnHLineView){
        _btnHLineView = [UIView new];
        _btnHLineView.backgroundColor = UIColorFromRGB(0x555555);
        [self.containView addSubview:_btnHLineView];
    }
    return _btnHLineView;
}

- (UIView *)bgView
{
    if (!_bgView) {
        _bgView = [[UIView alloc] initWithFrame:self.bounds];
        _bgView.backgroundColor = [UIColor blackColor];
        _bgView.alpha = 0.6;
        [self addSubview:_bgView];
    }
    return _bgView;
}

- (UIView *)containView
{
    if (!_containView) {
        _containView = [[UIView alloc] initWithFrame:CGRectMake((RMI_IPHONE_WIDTH - P_ContainWidth)/2, 100, P_ContainWidth, 0)];
        _containView.center = self.center;
        _containView.layer.masksToBounds = YES;
        _containView.layer.cornerRadius = 13;
        _containView.backgroundColor = UIColorFromRGBA(0x272727, 1.0);
        [self addSubview:_containView];
    }
    return _containView;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _titleLabel.numberOfLines = 0;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.containView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (UILabel *)contentLabel
{
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.textColor = UIColorFromRGB(0xFFFFFF);
        _contentLabel.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _contentLabel.numberOfLines = 0;
        [self.containView addSubview:_contentLabel];
    }
    return _contentLabel;
}

-(UIView *)contentInputView
{
    if(!_contentInputView){
        _contentInputView = [UIView new];
        _contentInputView.layer.borderColor = UIColorFromRGB(0x4D4D4D).CGColor;
        _contentInputView.layer.borderWidth = 0.5;
        _contentInputView.layer.cornerRadius = 2.0;
        _contentInputView.clipsToBounds = YES;
        [self.containView addSubview:_contentInputView];
        [_contentInputView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(12);
            make.left.mas_equalTo(self.containView.mas_left).offset(Min_Left_Space);
            make.right.mas_equalTo(self.containView.mas_right).offset(-Min_Left_Space);
            make.height.equalTo(@28);
        }];
        
        _contentInputField = [UITextField new];
        _contentInputField.font = [UIFont systemFontOfSize:13 weight:UIFontWeightRegular];
        _contentInputField.textColor = [UIColor whiteColor];
//        UIButton *clearButton = [_contentInputField valueForKey:@"_clearButton"];
//        [clearButton setImage:[UIImage imageNamed:@"RMI_Clean_B"] forState:UIControlStateNormal];
        _contentInputField.delegate = self;
        _contentInputField.clearButtonMode=UITextFieldViewModeAlways;
        [_contentInputView addSubview:_contentInputField];
        [_contentInputField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(_contentInputView).offset(5);
            make.right.mas_equalTo(_contentInputView).offset(-5);
            make.top.bottom.mas_equalTo(_contentInputView);
        }];
    }
    return _contentInputView;
}

@end
