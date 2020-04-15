//
//  SKProduct+SSPriceConvertion.h
//  Smart Unite
//
//  Created by Varun Tomar on 08/02/16.
//  Copyright © 2016 CoreBits Software Solutions Pvt. Ltd. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface SKProduct (SSPriceConvertion)

@property (nonatomic, readonly) NSString *formattedPriceForPorduct;
- (NSString *)formattedPriceForValue:(NSNumber *)tempPrice;
@end
