//
//  ALTransationsManager+AppDeletageInstance.m
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "ALTransationsManager+AppDeletageInstance.h"

#import <AppKit/AppKit.h>
#import "Constants.h"
#import <StoreKit/StoreKit.h>
#import "Screen_Mirror_to_TV___Device-Swift.h"

@implementation ALTransationsManager (AppDeletageInstance)

+ (instancetype)appDelegateRetainedInstance
{
    AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
    if (appDelegate.transactionObserver == nil) {
        appDelegate.transactionObserver = [[ALTransationsManager alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:appDelegate.transactionObserver];//Handle the payments
        [appDelegate.transactionObserver resetTransactionBlock];
    }
    return appDelegate.transactionObserver;
}

-(void)resetTransactionBlock
{
    __block __weak ALTransationsManager *weakSelf = self;
    AppDelegate *appDelegate = (AppDelegate *)[NSApp delegate];
    self.stateObserver = appDelegate;
    self.transactionCompletionBlock = ^(SKPaymentTransaction *transaction, ALPURCHASESTATE state, NSString *updatedStatusMessage){
            dispatch_async(dispatch_get_main_queue(), ^{
                switch (state) {
                    case ALPURCHASESTATE_SUCCESS:
                    {
//                        weakSelf.isPaidUser = YES;
                        //[weakSelf resetToolTip];
                        [weakSelf.stateObserver subscriptionIsDoneSuccessfullyWithPlan:transaction.payment.productIdentifier];

                    }
                        break;
                        
                    case ALPURCHASESTATE_SUCCESS_RESTORED:
                    {
                        //[weakSelf resetToolTip];
                        [weakSelf.stateObserver subscriptionIsRestoredSuccessfullyWithPlan:transaction.payment.productIdentifier];
                        
                    }
                        break;
                    case ALPURCHASESTATE_FAILED:
                    {
                        
                    }
                        break;
                    case ALPURCHASESTATE_INPROGRESS:
                    {
                        
                    }
                        break;
                    case ALPURCHASESTATE_UPDATING_MEMBERSHIP:
                    {
                        
                    }
                        break;
                    case ALPURCHASESTATE_UNKNOWN:
                    {
                        
                    }
                        break;
                    default:
                        break;
                }
            });

    };
}
@end
