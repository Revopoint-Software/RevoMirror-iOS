//
//  RMI_GuideVC.m
//  RevoScan_iOS
//
//  Created by 邓亮 on 2023/2/4.
//

#import "RMI_GuideVC.h"
#import <WebKit/WebKit.h>

@interface RMI_GuideVC ()<WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *webView;

@end

@implementation RMI_GuideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self navgationView];
    
    self.webView.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    self.edgesForExtendedLayout = UIRectEdgeNone;
        
    NSString *basePath = [NSString stringWithFormat:@"%@",[[NSBundle mainBundle] bundlePath]];
    NSString *filePath;
    NSString *code = @"en";
    if ([__currentLanguageStringValue isEqualToString:@"zh_CN"]) {
        code = @"zh";
    }
    if (self.type == RMI_GuideVC_Agrement){
        filePath = [NSString stringWithFormat:@"%@/Agreement_%@.pdf",basePath,code];
    }else if(self.type == RMI_GuideVC_Policy){
        filePath = [NSString stringWithFormat:@"%@/PrivacyPolicy_%@.pdf",basePath,code];
    }else{
        filePath = [NSString stringWithFormat:@"%@/Gplv3.pdf",basePath];
    }
    
    NSURL *pdfURL = [NSURL fileURLWithPath:filePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:pdfURL];
    [self.webView loadRequest:request];
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
    
    NSString *titleStr;
    if (self.type == RMI_GuideVC_Agrement){
        titleStr = RMI_MirrorStr_UserPolicy();
    }else if(self.type == RMI_GuideVC_Policy){
        titleStr = RMI_MirrorStr_PrivatePolicy();
    }else{
        titleStr = RMI_MirrorStr_Gplv3();
    }
    UILabel *titleLabel = [UILabel new];
    titleLabel.text = titleStr;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:18.0 weight:(UIFontWeightMedium)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [navView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(navView);
    }];
    
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn setImage:[UIImage imageNamed:@"RMI_Mirror_Back"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(rmi_handleActionBack) forControlEvents:UIControlEventTouchUpInside];
    [navView addSubview:backBtn];
    [backBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.mas_equalTo(navView);
        make.left.mas_equalTo(navView).offset(RMI_StatusBarHeight>0?RMI_StatusBarHeight:12);
        make.width.equalTo(@26);
    }];
    
    UIButton *backMsgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backMsgBtn setTitle:RMI_MirrorStr_Back() forState:(UIControlStateNormal)];
    [backMsgBtn setTitleColor:UIColorFromRGB(0xFFFFFF) forState:(UIControlStateNormal)];
    backMsgBtn.titleLabel.font = [UIFont systemFontOfSize:16.0 weight:(UIFontWeightRegular)];
    [backMsgBtn addTarget:self action:@selector(rmi_handleActionBack) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backMsgBtn];
    [backMsgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(backBtn.mas_right).offset(0);
        make.centerY.mas_equalTo(backBtn);
    }];
    
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame = CGRectMake(0,55,RMI_IPHONE_WIDTH,1);
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1.0, 0);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:1.0].CGColor,(__bridge id)[UIColor colorWithRed:67/255.0 green:67/255.0 blue:67/255.0 alpha:0.0].CGColor];
    gl.locations = @[@(0.0f),@(0.5f),@(1.0f)];
    [navView.layer addSublayer:gl];
}

-(void)rmi_handleActionBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler {
    NSLog(@"url = %@",navigationAction.request.URL);
    NSString * absoluteString = navigationAction.request.URL.absoluteString;
    if (navigationAction.navigationType == WKNavigationTypeLinkActivated && [absoluteString containsString:@"revopoint3d.com"]) {
        UIApplication *app = [UIApplication sharedApplication];
        if ([app canOpenURL:navigationAction.request.URL]) {
            [app openURL:navigationAction.request.URL options:@{} completionHandler:^(BOOL success) {
                
            }];
        }
    }
    decisionHandler(WKNavigationActionPolicyAllow);
}

- (WKWebView *)webView
{
    if (!_webView) {
        //配置信息
        WKWebViewConfiguration *config = [[WKWebViewConfiguration alloc] init];
        // 打开javascript交互 默认为YES
        config.preferences.javaScriptEnabled = YES;
        
        _webView = [[WKWebView alloc] initWithFrame:CGRectZero configuration:config];
        _webView.allowsBackForwardNavigationGestures = YES;
        _webView.navigationDelegate = self;
        _webView.autoresizesSubviews = YES;
        _webView.multipleTouchEnabled = YES;
        _webView.scrollView.showsVerticalScrollIndicator = NO;
        _webView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_webView];
        [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(52);
            make.bottom.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view).offset(0);
            make.right.mas_equalTo(self.view).offset(0);
        }];
    }
    return _webView;
}

@end
