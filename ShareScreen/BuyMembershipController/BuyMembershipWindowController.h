//
//  BuyMembershipWindowController.h
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Cocoa/Cocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface BuyMembershipWindowController : NSWindowController<NSWindowDelegate>

-(void)setSubscriptionPlansFromStoreCompetionBlock:(void (^)(BOOL isComplete, BOOL isTransactionSuccessful,NSString *planName))completionBlock;

@end

NS_ASSUME_NONNULL_END
