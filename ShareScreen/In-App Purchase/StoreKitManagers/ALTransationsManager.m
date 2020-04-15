 //
//  ALTransationsManager.m
//  Amazon Lister
//
//  Created by Satendra Dagar on 27/07/15.
//  Copyright (c) 2015 CoreBits. All rights reserved.
//


#import "ALTransationsManager.h"
#import "JSReceiptRefreshRequest.h"
#import "ALStoreListController.h"
#import "ALTransationsManager+AppDeletageInstance.h"


@interface ALTransationsManager()
{

}

@property (nonatomic, copy) void (^restoreErrorBlock)(NSString *errorMessage);

@end

@implementation ALTransationsManager


- (instancetype)init
{
    self = [super init];
    if (self) {
        [self resetTransactionBlock];
    }
    return self;
}


- (void)addTransactionUpdateHanldler:(void (^)(SKPaymentTransaction *transaction, ALPURCHASESTATE state, NSString *updatedStatusMessage))completionBlock
{
    self.transactionCompletionBlock = completionBlock;
}

- (void)purchaseProduct:(SKProduct *)product errorMessageBlock: (void (^)(NSString *errorMessage))errorBlock
{
    
    [self generateOrderIdAndBuyProduct:product errorMessageBlock:errorBlock];
}

- (void)restoreProductsWitherrorMessageBlock: (void (^)(NSString *errorMessage))errorBlock
{
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

#pragma mark-
#pragma mark-

- (void)generateOrderIdAndBuyProduct:(SKProduct *)product errorMessageBlock: (void (^)(NSString *errorMessage))errorBlock
{
    if ([SKPaymentQueue canMakePayments]) {
        if (product.productIdentifier) {
            
            SKMutablePayment *payment = [SKMutablePayment paymentWithProduct:product];
            payment.applicationUsername = @"";
//            [[NSUserDefaults standardUserDefaults] setObject:payment.applicationUsername forKey:kLastParsePaymentID];
            [[SKPaymentQueue defaultQueue] addPayment:payment];
        }
        else
        {
            errorBlock(@"Something Went wrong");
        }
    }
    else
    {
        errorBlock(UNAUTORIZED_PAYMENT_ACCESS);

    }
}


- (void)recordCompletedTransation:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction];

}

- (void)recordFailedTransation:(SKPaymentTransaction *)transaction
{
    [self finishTransaction:transaction];
}

- (void)finishTransaction:(SKPaymentTransaction *)transaction
{
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
}

#pragma mark-
#pragma mark- Transaction observer

- (void)paymentQueue:(SKPaymentQueue *)queue
 updatedTransactions:(NSArray *)transactions {
    

    for (SKPaymentTransaction *transaction in transactions) {
        NSLog(@"updatedTransaction:%@:%ld",transaction,(long)transaction.transactionState);

        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.

            case SKPaymentTransactionStatePurchasing:
            self.transactionCompletionBlock(transaction,ALPURCHASESTATE_INPROGRESS,@"Transaction is being made, please hold on..");
                break;
            case SKPaymentTransactionStateDeferred:
            self.transactionCompletionBlock(transaction,ALPURCHASESTATE_INPROGRESS,@"Transaction deferred");
                break;
            case SKPaymentTransactionStateFailed:
                [self recordFailedTransation:transaction];
            self.transactionCompletionBlock(transaction,ALPURCHASESTATE_FAILED,@"Transaction failed");
                NSLog(@"Error:%@",transaction.error);

                break;
            case SKPaymentTransactionStatePurchased:
                [self recordCompletedTransation:transaction];
            self.transactionCompletionBlock(transaction,ALPURCHASESTATE_SUCCESS,@"Transaction successful");
                break;
            case SKPaymentTransactionStateRestored:
                [self recordCompletedTransation:transaction];
                //When transaction is restored on other machine of user.
            self.transactionCompletionBlock(transaction,ALPURCHASESTATE_SUCCESS_RESTORED,@"Transaction restored");
                break;
            default:
                // For debugging
             self.transactionCompletionBlock(transaction,ALPURCHASESTATE_UNKNOWN,@"!!! Unexpected behaviour !!!");

                NSLog(@"Unexpected transaction state %@",
                      @(transaction.transactionState));
            break;
        }
    }
}

// Sent when transactions are removed from the queue (via finishTransaction:).
- (void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions {
    
}

// Sent when an error is encountered while adding transactions from the user's purchase history back to the queue.
- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    
    NSLog(@"restoreCompletedTransactionsFailedWithError:%@",error.localizedDescription);
self.transactionCompletionBlock(queue.transactions.firstObject,ALPURCHASESTATE_FAILED_RESTORED,error.localizedDescription);

    if (self.restoreErrorBlock) {

        self.restoreErrorBlock(error.domain);

    }
}

// Sent when all transactions from the user's purchase history have successfully been added back to the queue.
- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {

    NSLog(@"paymentQueueRestoreCompletedTransactionsFinished:%@",queue.transactions);
    if (queue.transactions.count) {
//        self.transactionCompletionBlock(queue.transactions.firstObject,ALPURCHASESTATE_SUCCESS_RESTORED_Completed,@"Transaction restored Completed");

    }
    else{
        self.transactionCompletionBlock(queue.transactions.firstObject,ALPURCHASESTATE_SUCCESS_RESTORED_Completed,@"No purchase transaction to restored");

    }

}

@end
