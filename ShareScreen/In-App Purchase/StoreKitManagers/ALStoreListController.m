//
//  JSStoreListController.m
//  Smart Reminder
//
//  Created by Satendra Dagar on 23/07/15.
//  Copyright (c) 2015 CoreBits. All rights reserved.
//


#import "Constants.h"

#import "ALStoreListController.h"
//
typedef void (^ALStoreListCompletion)(BOOL isSuccess, NSError *error);

@interface ALStoreListController()<SKProductsRequestDelegate>

- (void)validateProductIdentifiers:(NSArray *)productIdentifiers;
- (void)fillPossibleProductIds;

@end

@implementation ALStoreListController
{
    NSMutableArray *possibleProductIDs;
    SKProductsRequest *productsRequest;
    ALStoreListCompletion completionBlock;
    NSArray *receivedStoreProducts;
    NSNumberFormatter *numberFormatter;
}

#pragma mark-
#pragma mark- configuration related methods

- (BOOL)configureProductsWithCompletionHanldler:(void (^)(BOOL isSuccess, NSError *error))completion
{
    completionBlock = completion;
    [self fillPossibleProductIds];
    [self validateProductIdentifiers:possibleProductIDs];
    return YES;
}

/*
 Fill all possible product IDs in a array, that is to be used to initialize SKProductsRequest
 */
- (void)fillPossibleProductIds
{
    possibleProductIDs = [[NSMutableArray alloc] init];
    [possibleProductIDs addObjectsFromArray:@[InAppPremiumPlan]];
}


#pragma mark-
#pragma mark- StoreKit related methods/delegates

// Custom method : Request product upgrade data
- (void)validateProductIdentifiers:(NSArray *)productIdentifiers
{
    productsRequest = [[SKProductsRequest alloc]
                                          initWithProductIdentifiers:[NSSet setWithArray:productIdentifiers]];
    productsRequest.delegate = self;
    [productsRequest start];
}

// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request
     didReceiveResponse:(SKProductsResponse *)response
{
    //Products recieved from apple store
    receivedStoreProducts = response.products;
    //response.products is nil and your product id shows up in the response.invalidProductIdentifers array, then there is something wrong.
    NSLog(@"Invalid List = \n%@",
          response.invalidProductIdentifiers);
    for (NSString *invalidIdentifier in response.invalidProductIdentifiers) {
        NSLog(@"\ninvalidIdentifierID: %@",invalidIdentifier);
        // Handle any invalid product identifiers.
    }
    
    //We can notify from here if we have fetced products identifiers : Not required
    [[NSNotificationCenter defaultCenter] postNotificationName:kInAppPurchaseManagerProductsFetchedNotification object:self userInfo:nil];
}

- (void)requestDidFinish:(SKRequest *)request {
    completionBlock(YES,nil);
    productsRequest = nil;
    NSLog(@"requestDidFinish:%@",request);

}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    completionBlock(NO,error);
    productsRequest = nil;
    NSLog(@"didFailWithError:%@",error);

}

#pragma mark-
#pragma mark filter local product list with appstore list

- (NSString *)formattedPriceForPorduct:(SKProduct *)product
{
    if (nil == numberFormatter) {
        numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:product.priceLocale];
    }
    NSString *formattedPrice = [numberFormatter stringFromNumber:product.price];
    return formattedPrice;
}

- (SKProduct *)productWithProductIdentifier:(NSString *)identifier
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.productIdentifier == %@",identifier];
    NSArray *filteredProducts = [receivedStoreProducts filteredArrayUsingPredicate:predicate];
    if (filteredProducts.count) {
        return [filteredProducts firstObject];
    }
    return nil;
}

-(NSArray *)fetchRecievedProductsFromStore
{
    return receivedStoreProducts;
}

@end
