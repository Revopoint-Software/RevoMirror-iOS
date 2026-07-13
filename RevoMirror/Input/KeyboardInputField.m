//
//  KeyboardInputField.m
//  Revo Mirror
//
//  Created by Cameron Gutman on 12/2/22.
//  Copyright © 2022 RevoMirror Project. All rights reserved.
//

#import "KeyboardInputField.h"

@implementation KeyboardInputField

- (UIEditingInteractionConfiguration) editingInteractionConfiguration {
    // Suppress the Undo menu that appears with a 3 finger tap
    return UIEditingInteractionConfigurationNone;
}

@end
