//
//  SSCustomButton.h
//  Smart Reminder
//
//  Created by Satendra Singh on 07/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt. Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSCustomButton : NSButton

@property (nonatomic, strong) IBInspectable NSColor *BGColor;
@property (nonatomic, strong) IBInspectable NSColor *TextColor;
@property (nonatomic) IBInspectable CGFloat CornerRadius;
@property (nonatomic, strong) IBInspectable NSColor *BorderColor;

@end

NS_ASSUME_NONNULL_END
