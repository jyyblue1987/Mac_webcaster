//
//  Constants.m
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "Constants.h"
#import <AppKit/AppKit.h>

NSString * const InAppPremiumPlan =  @"com.CoreBits.smartReminder.premium";


@implementation Constants

+(void)showAlert:(NSString *)message{
    NSAlert *alert = [[NSAlert alloc] init];
    
    [alert addButtonWithTitle:@"OK"];//will generate a return code of 1002
    [alert setMessageText:@"Screen Mirror to TV & Device"];
    [alert setInformativeText:message];
    [alert setAlertStyle:NSAlertStyleInformational];
    [alert runModal];

}

@end
