//
//  RMI_ScanSettingCell.m
//  RevoScan_iOS
//
//  Created by 邓亮 on 2022/11/14.
//

#import "RMI_SettingCell.h"

@interface RMI_SettingCell ()

@property(nonatomic,strong)UILabel *contentLabel;
@property(nonatomic,strong)UIImageView *rowImgView;
@property(nonatomic,strong)UILabel *subLabel;
@property(nonatomic,strong)CAGradientLayer *gl;

@end

@implementation RMI_SettingCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        // gradient
        _gl = [CAGradientLayer layer];
        _gl.frame = CGRectMake(0,0,340,52);
        _gl.startPoint = CGPointMake(0, 0);
        _gl.endPoint = CGPointMake(1.0, 0);
        _gl.colors = @[(__bridge id)[UIColor colorWithRed:230/255.0 green:69/255.0 blue:69/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:230/255.0 green:69/255.0 blue:69/255.0 alpha:1.0].CGColor];
        _gl.locations = @[@(0.0f), @(1.0f)];
        [self.selectedBackgroundView.layer addSublayer:_gl];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = UIColorFromRGB(0x383838);
        [self createUI];
    }
    return self;
}

-(void)setSelected:(BOOL)selected
{
    if(self.selectionStyle != UITableViewCellSelectionStyleNone){
        [super setSelected:selected];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            self.subLabel.textColor = selected?[UIColor whiteColor]:UIColorFromRGB(0x999999);
        });
    }
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    if(self.selectionStyle != UITableViewCellSelectionStyleNone){
        [super setHighlighted:highlighted animated:animated];
//        self.subLabel.textColor = highlighted?[UIColor whiteColor]:UIColorFromRGB(0x999999);
    }
}

-(void)createUI
{
    [self contentLabel];
}

-(void)updateCellString:(NSString *)titleString subString:(NSString *)subString selectBlue:(BOOL)selectBlue needCheck:(BOOL)needCheck
{
    self.contentLabel.text = titleString;
    self.subLabel.hidden = subString.length>0?NO:YES;
    self.subLabel.text = subString;
    
    if(selectBlue){
        self.contentLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        self.rowImgView.image = [UIImage imageNamed:@"RMI_Setting_More"];
        self.gl.frame = CGRectMake(0,0,340,52);
        self.gl.colors = @[(__bridge id)[UIColor colorWithRed:230/255.0 green:69/255.0 blue:69/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:230/255.0 green:69/255.0 blue:69/255.0 alpha:1.0].CGColor];
    }else{
        self.contentLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        self.rowImgView.image = needCheck?[UIImage imageNamed:@"RMI_LanguageSelect"]:nil;
        float bar = RMI_StatusBarHeight>0?RMI_StatusBarHeight+(IS_PhoneXAll?8:0):16;
        self.gl.frame = CGRectMake(0,0,RMI_IPHONE_WIDTH-340-bar-32-16,52);
        self.gl.colors = @[(__bridge id)[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:89/255.0 green:89/255.0 blue:89/255.0 alpha:1.0].CGColor];
    }
}

-(UILabel *)contentLabel
{
    if(!_contentLabel){
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:18 weight:UIFontWeightMedium];
        _contentLabel.textColor = [UIColor whiteColor];
        [self addSubview:_contentLabel];
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self).offset(0);
            make.left.mas_equalTo(self).offset(16);
        }];
    }
    return _contentLabel;
}

-(UIImageView *)rowImgView
{
    if(!_rowImgView){
        _rowImgView = [UIImageView new];
        _rowImgView.image = [UIImage imageNamed:@"RMI_Setting_More"];
        [self addSubview:_rowImgView];
        [_rowImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self).offset(-12);
            make.centerY.mas_equalTo(self);
        }];
    }
    return _rowImgView;
}

-(UILabel *)subLabel
{
    if(!_subLabel){
        _subLabel = [UILabel new];
        _subLabel.text = @"";
        _subLabel.font = [UIFont systemFontOfSize:16 weight:UIFontWeightRegular];
        _subLabel.textColor = [UIColor whiteColor];
        [self addSubview:_subLabel];
        [_subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(self).offset(0);
            make.right.mas_equalTo(self.rowImgView.mas_left).offset(-7);
        }];
    }
    return _subLabel;
}

@end
