//
//  ALTransationsManager.h
//  Amazon Lister
//
//  Created by Satendra Dagar on 27/07/15.
//  Copyright (c) 2015 CoreBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

#import "InAppPurchaseStateChangeProtocol.h"
#import "Constants.h"

typedef void (^ALTransationCompletion)(SKPaymentTransaction *transaction, ALPURCHASESTATE state, NSString *updatedStatusMessage);

@interface ALTransationsManager : NSObject <SKPaymentTransactionObserver>

@property (nonatomic, copy) ALTransationCompletion transactionCompletionBlock;

@property (nonatomic, weak) id<InAppPurchaseStateChangeProtocol> stateObserver;

- (void)addTransactionUpdateHanldler:(void (^)(SKPaymentTransaction *transaction, ALPURCHASESTATE state, NSString *updatedStatusMessage))completionBlock;

- (void)purchaseProduct:(SKProduct *)product errorMessageBlock: (void (^)(NSString *errorMessage))errorBlock;

- (void)restoreProductsWitherrorMessageBlock: (void (^)(NSString *errorMessage))errorBlock;



@end
