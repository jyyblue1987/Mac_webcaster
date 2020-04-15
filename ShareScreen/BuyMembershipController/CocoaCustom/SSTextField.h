//
//  SSTextField.h
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 08/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface SSTextField : NSTextField

@property (nonatomic) IBInspectable CGFloat CornerRadius;
@property (nonatomic, strong) IBInspectable NSColor *BorderColor;

@end

NS_ASSUME_NONNULL_END
