//
//  RMI_SetViewController.m
//  Revo Mirror
//
//  Created by 邓亮 on 2025/8/14.
//  Copyright © 2025 RevoMirror Project. All rights reserved.
//

#import "RMI_SetViewController.h"
#import "RMI_SettingCell.h"
#import "RMI_AboutView.h"

@interface RMI_SetViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITableView *titleTable;//左边标题列表
@property(nonatomic,strong)UITableView *contentTable;//对应右边的内容选项列表
@property(nonatomic,strong)NSMutableArray *titleArray;//左边数据数数组
@property(nonatomic,strong)NSMutableArray *contentArray;//右边数据数组
@property(nonatomic,copy)NSArray *langCodeArray;//多语言存储-key-固定的，跟语言选择顺序必须保持一致

@property(nonatomic,copy)NSString *languageString;
@property(nonatomic,strong)RMI_AboutView *aboutView;//关于页面


@end

@implementation RMI_SetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0x2B2B2B);
    
    [self navgationView];
    
    self.langCodeArray = @[@"",@"zh_CN",@"zh_HK",@"en_US",@"ja",@"es",@"fr",@"de",@"ko",@"it",@"ru",@"pt",@"tr"];
    self.titleArray = [NSMutableArray new];
    self.contentArray = [NSMutableArray new];
    
    self.languageString = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentLanguageStringValue"];
    if (!self.languageString) {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"currentLanguageStringValue"];
        self.languageString = @"";
    }
    NSArray *cArray = @[RMI_MirrorStr_AutoSystem(),@"简体中文",@"繁體中文",@"English",@"日本語",@"Español",@"Français",@"Deutsch",@"한국어",@"Italiano",@"русский",@"Português",@"Türkçe"];
    NSArray *tArray = @[RMI_MirrorStr_Language(),RMI_MirrorStr_About()];
    for (int x = 0; x<tArray.count; x++) {
        [self.titleArray addObject:tArray[x]];
    }
    
    for (int x = 0; x<cArray.count; x++) {
        [self.contentArray addObject:cArray[x]];
    }
    
    [self.titleTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(16);
        make.top.mas_equalTo(self.view).offset(72);
        make.width.equalTo(@340);
        make.bottom.mas_equalTo(self.view).offset(-16);
    }];
    
    [self.contentTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleTable.mas_right).offset(32);
        make.top.mas_equalTo(self.titleTable);
        make.right.mas_equalTo(self.view).offset(-16);
        make.bottom.mas_equalTo(self.view).offset(-16);
    }];
        
    self.contentTable.hidden = NO;
    self.aboutView.hidden = YES;
    
    //默认选中第一行
    [self.titleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
    [self.contentTable reloadData];
    
    UIView *lineView = [UIView new];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(56);
        make.bottom.mas_equalTo(self.view).offset(0);
        make.width.equalTo(@1);
        make.left.mas_equalTo(self.titleTable.mas_right).offset(16);
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,0,1,RMI_IPHONE_HEIGHT-56);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(0, 1.0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor];
    gl.locations = @[@(0.0f),@(0.5f),@(1.0f)];
    [lineView.layer addSublayer:gl];
    
    [self updateDeviceOrientation];
}

-(void)navgationView
{
    UIView *navView = [UIView new];
    navView.backgroundColor = UIColorFromRGB(0x2B2B2B);
    [self.view addSubview:navView];
    [navView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self.view);
        make.height.equalTo(@56);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"RMI_Mirror_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(navView);
        make.left.mas_equalTo(self.titleTable).offset(0);
        make.width.equalTo(@26);
    }];
    
    UIButton *backMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backMsgBtn setTitle:RMI_MirrorStr_Back() forState:(UIControlStateNormal)];
    [backMsgBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    backMsgBtn.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:(UIFontWeightRegular)];
    [backMsgBtn addTarget:self action:@selector(backTo) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backMsgBtn];
    [backMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(backBtn);
    }];
    
    _titleLabel = [UILabel new];
    _titleLabel.text = RMI_MirrorStr_Setting();
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.font = [UIFont systemFontOfSize:18.0 weight:(UIFontWeightMedium)];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(navView);
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,55,RMI_IPHONE_WIDTH,1);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1.0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor];
    gl.locations = @[@(0.0f),@(0.5f),@(1.0f)];
    [navView.layer addSublayer:gl];
    
    RMI_WeakSelf(weakSelf)
    [self ts_RMI_ChangeLanguage:^{
        weakSelf.titleLabel.text = RMI_MirrorStr_Setting();
        [backMsgBtn setTitle:RMI_MirrorStr_Back() forState:(UIControlStateNormal)];
    }];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    [self updateDeviceOrientation];
}

-(void)updateDeviceOrientation
{
    if([RMI_Tools getWindowInterfaceOrientation]==UIInterfaceOrientationLandscapeLeft){
        //充电口朝向左边
        [self.titleTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(16);
        }];
        
        [self.contentTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-RMI_StatusBarHeight-12);
        }];
    }else{
        [self.titleTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.view).offset(RMI_StatusBarHeight+12);
        }];
        
        [self.contentTable mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.view).offset(-16);
        }];
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == self.titleTable){
        return 2;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.titleTable){
        return 1;
    }else{
        return self.contentArray.count;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 52;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == self.titleTable){
        return 8;
    }else{
        return 0.0001;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellName = @"RMI_SettingCell";
    RMI_SettingCell *cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if (!cell) {
        cell = [[RMI_SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellName];
    }
    
    if (indexPath.row == 0) {
        // 第一行顶部添加
        UIRectCorner corner = (tableView == self.titleTable && indexPath.section!=3)?(UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight):(UIRectCornerTopRight | UIRectCornerTopLeft);
        [self addRoundedCorners:corner withRadii:10 viewRect:CGRectMake(0, 0, tableView.frame.size.width, 52) view:cell];
    }
    if(tableView == self.titleTable){
        [cell updateCellString:self.titleArray[indexPath.section] subString:indexPath.section==0?[self.contentArray objectAtIndex:[self.langCodeArray indexOfObject:self.languageString]]:@"" selectBlue:YES needCheck:NO];
    }else{
        if(indexPath.row == self.contentArray.count-1){
            UIRectCorner corner = (UIRectCornerBottomLeft | UIRectCornerBottomRight);
            [self addRoundedCorners:corner withRadii:10 viewRect:CGRectMake(0, 0, tableView.frame.size.width, 52) view:cell];
        }else if(indexPath.row != 0){
            UIRectCorner corner = (UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerTopLeft | UIRectCornerTopRight);
            [self addRoundedCorners:corner withRadii:0 viewRect:CGRectMake(0, 0, tableView.frame.size.width, 52) view:cell];
        }
        [cell updateCellString:self.contentArray[indexPath.row] subString:@"" selectBlue:NO needCheck:[self.languageString isEqualToString:self.langCodeArray[indexPath.row]]];
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.titleTable){
        if(indexPath.section == 0){
            //语言
            self.contentTable.hidden = NO;
            self.aboutView.hidden = YES;
            [self.titleTable reloadData];
            [self.contentTable reloadData];
            [self.titleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];

        }else if(indexPath.section == 1){
            self.contentTable.hidden = YES;
            self.aboutView.hidden = NO;
            [self.titleTable reloadData];
            [self.titleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1] animated:YES scrollPosition:(UITableViewScrollPositionNone)];

        }
    }else{
        [[NSUserDefaults standardUserDefaults] setObject:self.langCodeArray[indexPath.row] forKey:@"currentLanguageStringValue"];
        self.languageString = self.langCodeArray[indexPath.row];
        __currentLanguageStringValue = [UIDevice appDeviceDefaultLanguage];
                
        NSArray *cArray = @[RMI_MirrorStr_AutoSystem(),@"简体中文",@"繁體中文",@"English",@"日本語",@"Español",@"Français",@"Deutsch",@"한국어",@"Italiano",@"русский",@"Português",@"Türkçe"];
        [self.contentArray removeAllObjects];
        for (int x = 0; x<cArray.count; x++) {
            [self.contentArray addObject:cArray[x]];
        }
        
        NSArray *tArray = @[RMI_MirrorStr_Language(),RMI_MirrorStr_About()];
        [self.titleArray removeAllObjects];
        for (int x = 0; x<tArray.count; x++) {
            [self.titleArray addObject:tArray[x]];
        }
        
        [self.titleTable reloadData];
        [self.titleTable selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionNone)];
        [self.contentTable reloadData];
        [RMI_TSNotificationCenter call_RMI_ChangeLanguage];
    }
}

-(void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGFloat)radii
                 viewRect:(CGRect)rect
                    view:(UIView *)view
{
    UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:CGSizeMake(radii, radii)];
    CAShapeLayer* shape = [[CAShapeLayer alloc] init];
    [shape setPath:rounded.CGPath];
    
    view.layer.mask = shape;
}


-(void)backTo
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (UITableView *)titleTable
{
    if (!_titleTable) {
        _titleTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _titleTable.delegate = self;
        _titleTable.dataSource = self;
        _titleTable.backgroundColor = [UIColor clearColor];
        _titleTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _titleTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _titleTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        _titleTable.estimatedRowHeight = 52;
        _titleTable.rowHeight = UITableViewAutomaticDimension;
        _titleTable.estimatedSectionHeaderHeight = 0;
        _titleTable.estimatedSectionFooterHeight = 0;
        _titleTable.showsVerticalScrollIndicator = NO;
        [self.view addSubview:_titleTable];
    }
    return  _titleTable;
}

- (UITableView *)contentTable
{
    if (!_contentTable) {
        _contentTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _contentTable.delegate = self;
        _contentTable.dataSource = self;
        _contentTable.backgroundColor = [UIColor clearColor];
        _contentTable.layer.cornerRadius = 10.0;
        _contentTable.clipsToBounds = YES;
        _contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        if (@available(iOS 11.0, *)) {
            _contentTable.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            _contentTable.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
        _contentTable.estimatedRowHeight = 52;
        _contentTable.rowHeight = UITableViewAutomaticDimension;
        _contentTable.estimatedSectionHeaderHeight = 0;
        _contentTable.estimatedSectionFooterHeight = 0;
        _contentTable.showsVerticalScrollIndicator = YES;
        [self.view addSubview:_contentTable];
    }
    return  _contentTable;
}

-(RMI_AboutView *)aboutView
{
    if(!_aboutView){
        _aboutView = [[RMI_AboutView alloc] init];
        _aboutView.backgroundColor = UIColorFromRGB(0x383838);
        _aboutView.layer.cornerRadius = 8.0;
        _aboutView.clipsToBounds = YES;
        [self.view addSubview:_aboutView];
        [_aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.contentTable);
            make.top.mas_equalTo(self.contentTable);
            make.right.mas_equalTo(self.contentTable);
            make.bottom.mas_equalTo(self.view).offset(-16);
        }];
    }
    return _aboutView;
}

@end
