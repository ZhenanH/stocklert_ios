//
//  IAPHelper.h
//  In-app purchase
//
//  Created by Zhenan Hong on 12/13/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

@interface IAPHelper : NSObject

- (void)buyProduct:(SKProduct *)product;
- (BOOL)productPurchased:(NSString *)productIdentifier;

- (id)initWithProductIdentifiers:(NSSet *)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)restoreCompletedTransactions;

@end
