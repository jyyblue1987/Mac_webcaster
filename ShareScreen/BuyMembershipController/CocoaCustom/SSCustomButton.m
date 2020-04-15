//
//  SSCustomButton.m
//  Smart Reminder
//
//  Created by Satendra Singh on 07/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt. Ltd. All rights reserved.
//

#import "SSCustomButton.h"

@implementation SSCustomButton


- (void)awakeFromNib
{
    if (self.TextColor)
        [self setAttributedTitle:[self textColor:self.TextColor]];

    if (self.CornerRadius)
    {
        [self setWantsLayer:YES];
        self.layer.masksToBounds = TRUE;
        self.layer.cornerRadius = self.CornerRadius;
        self.layer.borderWidth = 1;
        self.layer.borderColor = self.BorderColor.CGColor;
    }
}

-(void)setTitle:(NSString *)title{
    [super setTitle:title];
    if (self.TextColor)
        [self setAttributedTitle:[self textColor:self.TextColor]];


}

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.BGColor)
    {
        [self.BGColor setFill];
        NSRectFill(dirtyRect);
    }

    [super drawRect:dirtyRect];
}



- (NSAttributedString*)textColor:(NSColor*)color
{
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setAlignment:NSTextAlignmentCenter];
    NSDictionary *attrsDictionary  = [NSDictionary dictionaryWithObjectsAndKeys:
                                      color, NSForegroundColorAttributeName,
                                      self.font, NSFontAttributeName,
                                      style, NSParagraphStyleAttributeName, nil];
    NSAttributedString *attrString = [[NSAttributedString alloc]initWithString:self.title attributes:attrsDictionary];
    return attrString;
}

@end
