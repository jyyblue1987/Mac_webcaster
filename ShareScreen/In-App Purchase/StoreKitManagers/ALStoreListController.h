//
//  JSStoreListController.h
//  Smart Reminder
//
//  Created by Satendra Dagar on 23/07/15.
//  Copyright (c) 2015 CoreBits. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

@interface ALStoreListController : NSObject
{

}

-(NSArray *)fetchRecievedProductsFromStore;
- (NSString *)formattedPriceForPorduct:(SKProduct *)product;
- (BOOL)configureProductsWithCompletionHanldler:(void (^)(BOOL isSuccess, NSError *error))completion;

@end
