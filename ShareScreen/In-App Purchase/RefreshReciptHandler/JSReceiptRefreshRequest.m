//
//  JSReceiptRefreshRequest.m
//  Smart Reminder
//
//  Created by Satendra Dagar on 10/12/15.
//  Copyright © 2015 CoreBits. All rights reserved.
//

#import "JSReceiptRefreshRequest.h"
#import "ALTransationsManager.h"

typedef void (^ReceiptRefreshCompletion)(BOOL isSuccess, NSError *error,JSReceiptRefreshRequest *request);

@interface JSReceiptRefreshRequest ()

@property (nonatomic, readwrite, retain) SKPaymentTransaction *associatedTransaction;

@property (nonatomic, copy)  ReceiptRefreshCompletion completion;

@end

@implementation JSReceiptRefreshRequest

-(instancetype)initWithTransaction:(SKPaymentTransaction *)transaction completionHanldler:(void (^)(BOOL isSuccess, NSError *error, JSReceiptRefreshRequest *request))completion;
{
    self = [super initWithReceiptProperties:nil];
    if (self) {
        self.delegate = self;
        self.associatedTransaction = transaction;
        self.completion = completion;
    }
    return self;
}

- (void)requestDidFinish:(SKRequest *)request{
    
    NSLog(@"requestDidFinish");
    self.completion(YES, nil, self);
//    [[JSTransationsManager appDelegateRetainedInstance] syncTrancation:self.associatedTransaction isSuccess:YES tryRefreshReceipt:NO];
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{
    NSLog(@"request didFailWithError %@",[error localizedDescription]);
    self.completion(NO, error, self);
}

@end
