//
//  JSReceiptRefreshRequest.h
//  Smart Reminder
//
//  Created by Satendra Dagar on 10/12/15.
//  Copyright © 2015 CoreBits. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface JSReceiptRefreshRequest : SKReceiptRefreshRequest<SKRequestDelegate>

@property (nonatomic, readonly, retain) SKPaymentTransaction *associatedTransaction;

-(instancetype)initWithTransaction:(SKPaymentTransaction *)transaction completionHanldler:(void (^)(BOOL isSuccess, NSError *error, JSReceiptRefreshRequest *request))completion;

@end
