//
//  UIComputerView.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 10/22/14.
//  Copyright (c) 2014 RevoMirror. All rights reserved.
//

#import "UIComputerView.h"

@implementation UIComputerView {
    RMI_TemporaryHost* _host;
    UIImageView* _hostIcon;
    UILabel* _hostLabel;
    UILabel* _lastLabel;
    UIImageView* _hostOverlay;
    UIActivityIndicatorView* _hostSpinner;
    id<HostCallback> _callback;
    CGSize _labelSize;
}
static const float REFRESH_CYCLE = 2.0f;
static const int LABEL_DY = 20;

- (id) init {
    self = [super init];
    
    UIView *backView = [UIView new];
    backView.backgroundColor = UIColorFromRGB(0x414141);
    backView.layer.cornerRadius = 8.0;
    backView.clipsToBounds = YES;
    backView.userInteractionEnabled = NO;
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).offset(12);
        make.left.right.mas_equalTo(self);
        make.bottom.mas_equalTo(self).offset(-32);
    }];
    
    float width = (RMI_IPHONE_WIDTH-RMI_StatusBarHeight-24-12*4)/5.0;
    float hhh = width*200/266;
    self.frame = CGRectMake(0, 0, width, hhh+44);
    
    _hostIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, width, hhh)];
    _hostIcon.userInteractionEnabled = NO;
    _hostIcon.contentMode = UIViewContentModeCenter;
    [_hostIcon setImage:[UIImage imageNamed:@"RMI_Host_Normal"]];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(5,8);
    self.layer.shadowOpacity = 0.3;
    
    _hostLabel = [[UILabel alloc] init];
    _hostLabel.textColor = [UIColor whiteColor];
    _hostLabel.textAlignment = NSTextAlignmentCenter;
    _hostLabel.numberOfLines = 0;
    
    _hostOverlay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, width, hhh)];
    _hostOverlay.userInteractionEnabled = NO;
    _hostOverlay.contentMode = UIViewContentModeCenter;
    _hostSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleLarge];
    [_hostSpinner setFrame:_hostOverlay.frame];
    _hostSpinner.userInteractionEnabled = NO;
    _hostSpinner.hidesWhenStopped = YES;
    
    _lastLabel = [[UILabel alloc] init];
    _lastLabel.textColor = [UIColor whiteColor];
    _lastLabel.textAlignment = NSTextAlignmentCenter;
    _lastLabel.backgroundColor = UIColorFromRGB(0x5C5C5C);
    _lastLabel.hidden = YES;
    _lastLabel.font = [UIFont systemFontOfSize:12.0];

    [self addSubview:_hostLabel];
    [self addSubview:_lastLabel];
    [self addSubview:_hostIcon];
    [self addSubview:_hostOverlay];
    [self addSubview:_hostSpinner];
    
    [_lastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(backView);
        make.bottom.mas_equalTo(backView);
        make.width.equalTo(@20);
        make.height.equalTo(@20);
    }];
    [_hostLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(backView);
        make.height.equalTo(@(32));
        make.top.mas_equalTo(backView.mas_bottom).offset(0);
    }];
    
    if (@available(iOS 13.4.1, *)) {
        // Allow the button style to change when moused over
        self.pointerInteractionEnabled = YES;
    }
    
    RMI_WeakSelf(weakSelf);
    [self ts_RMI_ChangeLanguage:^{
        [weakSelf updateBounds];
    }];
    
    return self;
}

- (id) initForAddWithCallback:(id<HostCallback>)callback {
    self = [self init];
    _callback = callback;
    
    [self addTarget:self action:@selector(addClicked) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    [_hostLabel setText:@" "];
    [_hostLabel sizeToFit];
    
    [_hostOverlay setImage:[UIImage imageNamed:@"RMI_Host_Add"]];
    [_hostIcon setImage:nil];
    
    [self updateBounds];
        
    return self;
}

- (id) initWithComputer:(RMI_TemporaryHost*)host andCallback:(id<HostCallback>)callback {
    self = [self init];
    _host = host;
    _callback = callback;
    
    if (@available(iOS 13.0, *)) {
        UIContextMenuInteraction* rightClickInteraction = [[UIContextMenuInteraction alloc] initWithDelegate:self];
        [self addInteraction:rightClickInteraction];
    }
    else
    {
        UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(hostLongClicked:)];
        [self addGestureRecognizer:longPressRecognizer];
    }
    
    [self addTarget:self action:@selector(hostClicked) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    [self updateContentsForHost:host];

    return self;
}

- (void)didMoveToSuperview {
    // Start our update loop when we are added to our cell
    if (self.superview != nil && _host != nil) {
        [self updateLoop];
    }
}

- (void) updateBounds {
    _lastLabel.hidden = YES;
    if ([_host.activeAddress isEqualToString:__lastHost]) {
        NSString *lastStr = RMI_MirrorStr_Last();
        UIFont *font = [UIFont systemFontOfSize:12.0];
        CGSize size = [lastStr sizeWithAttributes:@{NSFontAttributeName:font}];
        float width2 = size.width+16;
        _lastLabel.hidden = NO;
        _lastLabel.text = lastStr;
        [_lastLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@(width2));
        }];
        
        UIRectCorner corner = (UIRectCornerBottomRight | UIRectCornerTopLeft);
        UIBezierPath* rounded = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, width2, 20) byRoundingCorners:corner cornerRadii:CGSizeMake(8, 8)];
        CAShapeLayer* shape = [[CAShapeLayer alloc] init];
        [shape setPath:rounded.CGPath];
        _lastLabel.layer.mask = shape;
    }
}

- (void) updateContentsForHost:(RMI_TemporaryHost*)host {
    _hostLabel.text = _host.name;
    [_hostLabel sizeToFit];
    
    if (host.state == StateOnline) {
        [_hostSpinner stopAnimating];

        if (host.pairState == PairStateUnpaired) {
            [_hostOverlay setImage:nil];
            [_hostIcon setImage:[UIImage imageNamed:@"RMI_Host_Normal"]];
        }
        else {
            [_hostOverlay setImage:nil];
            [_hostIcon setImage:[UIImage imageNamed:@"RMI_Host_Connected"]];
        }
    }
    else if (host.state == StateOffline) {
        [_hostSpinner stopAnimating];
        [_hostOverlay setImage:nil];
        [_hostIcon setImage:[UIImage imageNamed:@"RMI_Host_Offline"]];
    }
    else {
        [_hostSpinner startAnimating];
    }
    
    [self updateBounds];
}

- (void) updateLoop {
    // Stop immediately if the view has been detached
    if (self.superview == nil) {
        return;
    }
    
    [self updateContentsForHost:_host];
    
    // Queue the next refresh cycle
    [self performSelector:@selector(updateLoop) withObject:self afterDelay:REFRESH_CYCLE];
}

- (void) hostLongClicked:(UILongPressGestureRecognizer*)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {
        [_callback hostLongClicked:_host view:self];
    }
}

- (UIContextMenuConfiguration *)contextMenuInteraction:(UIContextMenuInteraction *)interaction
                        configurationForMenuAtLocation:(CGPoint)location {
    // We don't want to trigger the primary action at this point, so cancel
    // tracking touch on this view now. This will also have the (intended)
    // effect of removing the touch highlight on this view.
    [self cancelTrackingWithEvent:nil];
    
    [_callback hostLongClicked:_host view:self];
    return nil;
}

- (void) hostClicked {
    [_callback hostClicked:_host view:self];
}

- (void) addClicked {
    [_callback addHostClicked];
}

@end
