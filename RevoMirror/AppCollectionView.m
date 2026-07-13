//
//  AppCollectionView.m
//  Revo Mirror
//
//  Created by Diego Waxemberg on 9/30/15.
//  Copyright © 2015 RevoMirror. All rights reserved.
//

#import "AppCollectionView.h"

@implementation AppCollectionView

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
