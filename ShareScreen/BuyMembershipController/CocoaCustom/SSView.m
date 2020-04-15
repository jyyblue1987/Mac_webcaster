//
//  SSView.m
//  Smart Reminder
//
//  Created by Satendra Dagar on 20/03/16.
//
//

#import "SSView.h"

@implementation SSView

- (void)drawRect:(NSRect)dirtyRect
{
    if (self.bgColor)
    {
        // add a background colour
        [self.bgColor setFill];
        NSRectFill(dirtyRect);
    }
    
    [super drawRect:dirtyRect];
}


@end
