//
//  SSTextField.m
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 08/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "SSTextField.h"

@implementation SSTextField


- (void)awakeFromNib
{
    if (self.CornerRadius)
    {
        [self setWantsLayer:YES];
        self.layer.masksToBounds = TRUE;
        self.layer.cornerRadius = self.CornerRadius;
        self.layer.borderWidth = 1;
        self.layer.borderColor = self.BorderColor.CGColor;
    }
}


- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

@end
