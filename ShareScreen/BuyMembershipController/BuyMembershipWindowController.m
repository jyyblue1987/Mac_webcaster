//
//  BuyMembershipWindowController.m
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import "BuyMembershipWindowController.h"
#import "ALTransationsManager+AppDeletageInstance.h"
#import "ALStoreListController.h"
#import "SKProduct+SSPriceConvertion.h"

#define kProgressIndicatorWidth 50
#define kProgressIndicatorHeigth 50

#define kProgressMessageWidth 300
#define kProgressMessageHeight 100

typedef void (^ALSubscriptionCompletion)(BOOL isComplete, BOOL isTransactionSuccessful, NSString *planName);

@interface BuyMembershipWindowController ()
{
    __block SKPaymentTransaction *lastTransaction;
    __block ALPURCHASESTATE lastPaymentState;
    ALStoreListController *storeListController;
    NSArray *storeProductArray;
    NSString *planSubscribeFor;

    NSView *tempView;
    NSView *loadingView;
    NSProgressIndicator *progressIndicator;
}

@property (nonatomic, copy) ALSubscriptionCompletion subscriptionCompletionBlock;
@property (nonatomic,strong) SKProduct *nonConsumableProduct;

@property (weak) IBOutlet NSButton *btnBuyNow;
@property (weak) IBOutlet NSButton *priceLabel;
@property (weak) IBOutlet NSLayoutConstraint *priceButtonWidthConstraint;

@end

@implementation BuyMembershipWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    [self setupPaymentStatusHandlerBlocks];
    [self fetchSubscriptionPlansFromStore:nil];
    //To set button default selected
    [self.window setDefaultButtonCell:[_btnBuyNow cell]];
    
    [self.window center];
  
}

- (BOOL)windowShouldClose:(id)sender {
    [self continueFreeMembership:sender];
    return YES;
}

-(IBAction)buyMembership:(id)sender
{
    [self showLoader];
    if (nil == storeProductArray) {
        storeProductArray = [storeListController fetchRecievedProductsFromStore];
    }
    if (storeProductArray.count > 0) {
        planSubscribeFor = @"In-App Reminder Pro";
        [self performTransactionForProduct:self.nonConsumableProduct];

    }
}

-(IBAction)restoreMembership:(id)sender
{
    [self showLoader];
    [[ALTransationsManager appDelegateRetainedInstance] restoreProductsWitherrorMessageBlock:^(NSString *errorMessage) {
        NSLog(@"restoreProductsWitherrorMessageBlock:%@",errorMessage);
        
        [self hideLoader];
    }];
}


- (IBAction)continueFreeMembership:(id)sender{
    [self.window orderOut:nil];
    [NSApp endSheet:self.window];
    [NSApp stopModal];
}


-(void)performTransactionForProduct:(SKProduct *)product
{
    [[ALTransationsManager appDelegateRetainedInstance] purchaseProduct:product errorMessageBlock:^(NSString *errorMessage) {
        if ([errorMessage isEqualToString:UNAUTORIZED_PAYMENT_ACCESS]) {//Show alert message

            [Constants showAlert:UNAUTORIZED_PAYMENT_ACCESS];
        }
        [self hideLoader];
    }];
}



-(void)setSubscriptionPlansFromStoreCompetionBlock:(void (^)(BOOL isComplete,BOOL isTransactionSuccessful,NSString *planName))completionBlock;
{
    self.subscriptionCompletionBlock = completionBlock;
}

-(void)fetchSubscriptionPlansFromStore:(id)sender
{
    if (nil == storeListController) {
        storeListController = [ALStoreListController new];
    }
    
    [self showLoader];
    [storeListController configureProductsWithCompletionHanldler:^(BOOL isSuccess, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (isSuccess) {
                //Fill over detials here for different plans
                if (nil == self->storeProductArray) {
                    self->storeProductArray = [self->storeListController fetchRecievedProductsFromStore];
                    for (SKProduct *product in self->storeProductArray) {
                        if ([product.productIdentifier isEqualToString:PRODUCT_NON_CONSUMABLE]) {
                            self.nonConsumableProduct = product;
                            
                            self.priceLabel.title = product.formattedPriceForPorduct;
                            CGSize updatedSize = [self.priceLabel sizeThatFits:self.priceLabel.bounds.size];
                            self.priceButtonWidthConstraint.constant = updatedSize.width + 16;
                        }
                    }
                }
            }
            else{
                [Constants showAlert:error.localizedDescription];

            }
            [self hideLoader];
        });
    }];
}

- (void)setupPaymentStatusHandlerBlocks
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
    [[ALTransationsManager appDelegateRetainedInstance] addTransactionUpdateHanldler:^(SKPaymentTransaction *transaction, ALPURCHASESTATE state, NSString *updatedStatusMessage) {
        NSLog(@"%@",updatedStatusMessage);
        dispatch_async(dispatch_get_main_queue(), ^{
           // self->dynamicProgressMsg.stringValue = updatedStatusMessage;
            self->lastTransaction = transaction;
            self->lastPaymentState = state;
            switch (state) {
                case ALPURCHASESTATE_SUCCESS:
                {
                    [self hideLoader];
                    
                    [self.window orderOut:nil];
                    [NSApp endSheet:self.window];
                    self.subscriptionCompletionBlock(YES,YES,self->planSubscribeFor);
                    [Constants showAlert:updatedStatusMessage];

                    //[self closeWindow:nil];
                }
                    break;
                    
                case ALPURCHASESTATE_SUCCESS_RESTORED:
                {
                    [self hideLoader];
                    self.subscriptionCompletionBlock(YES,YES,@"Screen Mirror to TV & Device");
                    
                    [self.window orderOut:nil];
                    [NSApp endSheet:self.window];
                    [Constants showAlert:updatedStatusMessage];
                    //[self closeWindow:nil];
                }
                    break;
                case ALPURCHASESTATE_FAILED_RESTORED:
                {
                    NSLog(@"%@", updatedStatusMessage);
//                    [Constants showAlert:updatedStatusMessage];
                    [Constants showAlert:@"Restore Failed"];

                    [self hideLoader];
                }
                    break;
                case ALPURCHASESTATE_SUCCESS_RESTORED_Completed:
                {
                    NSLog(@"%@", updatedStatusMessage);
//                    [Constants showAlert:updatedStatusMessage];
                    [self hideLoader];
                }
                    break;

                case ALPURCHASESTATE_FAILED:
                {
                    NSString *errorMsg = transaction.error.debugDescription;
                    if (errorMsg.length == 0) {
                        NSLog(@"Err:%@",errorMsg);
//                        errorMsg = updatedStatusMessage;
                    }
                    [Constants showAlert:@"Payment Failed"];

                    [self hideLoader];
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
                     [self hideLoader];
                }
                    break;
                default:
                    break;
            }
        });
    }];
}



#pragma mark-- Loading Indicator

-(NSView *)loadingViewIndicator
{
    if (nil == loadingView) {
        loadingView = [[NSView alloc]initWithFrame:self.window.contentView.frame];
        [loadingView setWantsLayer:YES];
        [loadingView.layer setBackgroundColor:[[[NSColor blackColor]colorWithAlphaComponent:0.5] CGColor]];
        
        progressIndicator = [[NSProgressIndicator alloc]initWithFrame:NSRectFromCGRect(CGRectMake((self.window.contentView.frame.size.width/2) - (kProgressIndicatorWidth/2) , (self.window.contentView.frame.size.height/2) - (kProgressIndicatorHeigth/2), kProgressIndicatorWidth, kProgressIndicatorHeigth))];
        progressIndicator.style = NSProgressIndicatorStyleSpinning;
        
        [loadingView addSubview:progressIndicator];
    }
    return loadingView;
}

-(void)showLoader
{
    tempView = [self loadingViewIndicator];
    [progressIndicator startAnimation:nil];
    [self.window.contentView addSubview:tempView];
}

-(void)hideLoader
{
    [progressIndicator stopAnimation:nil];
    [tempView removeFromSuperview];
}

@end
