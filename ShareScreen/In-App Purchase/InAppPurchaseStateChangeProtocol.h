//
//  InAppPurchaseStateChangeProtocol.h
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#ifndef InAppPurchaseStateChangeProtocol_h
#define InAppPurchaseStateChangeProtocol_h

@protocol InAppPurchaseStateChangeProtocol <NSObject>

@optional
-(void)subscriptionIsDoneSuccessfullyWithPlan:(NSString *)planID;
-(void)subscriptionIsRestoredSuccessfullyWithPlan:(NSString *)planId;
-(void)activatePremiumMembership;

@end
#endif /* InAppPurchaseStateChangeProtocol_h */
