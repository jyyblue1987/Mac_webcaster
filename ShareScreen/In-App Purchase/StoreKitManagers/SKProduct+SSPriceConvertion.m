//
//  SKProduct+SSPriceConvertion.m
//  Smart Unite
//
//  Created by Varun Tomar on 08/02/16.
//  Copyright © 2016 CoreBits Software Solutions Pvt. Ltd. All rights reserved.
//

#import "SKProduct+SSPriceConvertion.h"

static NSNumberFormatter *numberFormatter;

@implementation SKProduct (SSPriceConvertion)

- (NSString *)formattedPriceForPorduct
{
    if (nil == numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:self.priceLocale];
    }
    NSString *formattedPrice = [numberFormatter stringFromNumber:self.price];
    return formattedPrice;
}


- (NSString *)formattedPriceForValue:(NSNumber *)tempPrice{
    
    if (nil == numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:self.priceLocale];
    }
    NSString *formattedPrice = [numberFormatter stringFromNumber:tempPrice];
    return formattedPrice;
}

@end
