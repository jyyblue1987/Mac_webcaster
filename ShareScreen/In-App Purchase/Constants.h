//
//  Constants.h
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

extern NSString * const InAppPremiumPlan;

#define kInAppPurchaseManagerProductsFetchedNotification @"kInAppPurchaseManagerProductsFetchedNotification"

#ifdef DEBUG
#define kVerifyRecieptUrl @"https://sandbox.itunes.apple.com/verifyReceipt" //for SANDBOX
#else
#define kVerifyRecieptUrl @"https://buy.itunes.apple.com/verifyReceipt"//for live
#endif




#define kInAppPurchaseManagerTransactionFailedNotification @"kInAppPurchaseManagerTransactionFailedNotification"
#define kInAppPurchaseManagerTransactionSucceededNotification @"kInAppPurchaseManagerTransactionSucceededNotification"

#define UNAUTORIZED_PAYMENT_ACCESS @"In-App purchases are disabled on your account. Enable In-App purchases for your account by going to Settings > General > Restrictions"

#define LATEST_SUBSCRIPTION_EXPIRY_DATE @"latestSubscriptionExpiryDate"
#define LATEST_SUBSCRIPTION_PRODUCT_ID @"latestSubscriptionProductId"

#define JS_Trans_State_Added @"A"
#define JS_Trans_State_Success @"S"
#define JS_Trans_State_Failure @"F"
#define JS_Trans_State_Initiated @"I"
#define JS_Trans_State_Canceled @"C"
#define JS_Trans_State_NoReceipt @"RNR_S"
#define YES_MSG @"Yes"

typedef enum : NSUInteger {
    ALPURCHASESTATE_SUCCESS,
    ALPURCHASESTATE_SUCCESS_RESTORED,
    ALPURCHASESTATE_SUCCESS_RESTORED_Completed,
    ALPURCHASESTATE_FAILED,
    ALPURCHASESTATE_FAILED_RESTORED,
    ALPURCHASESTATE_INPROGRESS,
    ALPURCHASESTATE_UPDATING_MEMBERSHIP,
    ALPURCHASESTATE_UNKNOWN
    
} ALPURCHASESTATE;

#define PRODUCT_NON_CONSUMABLE @"com.CoreBits.smartReminder.premium"


@interface Constants : NSObject

+(void)showAlert:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
