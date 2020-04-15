//
//  ALTransationsManager+AppDeletageInstance.h
//  In-App Purchase Sample
//
//  Created by Satendra Singh on 06/04/20.
//  Copyright © 2020 CoreBits Software Solutions Pvt Ltd. All rights reserved.
//

#import <AppKit/AppKit.h>


#import "ALTransationsManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface ALTransationsManager (AppDeletageInstance)

+ (instancetype)appDelegateRetainedInstance;

-(void)resetTransactionBlock;

@end

NS_ASSUME_NONNULL_END
