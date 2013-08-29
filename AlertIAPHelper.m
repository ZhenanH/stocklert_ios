//
//  AlertIAPHelper.m
//  In-app purchase
//
//  Created by Zhenan Hong on 12/13/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import "AlertIAPHelper.h"

@implementation AlertIAPHelper


+ (AlertIAPHelper *)sharedInstance {
    static dispatch_once_t once;
    static AlertIAPHelper * sharedInstance;
    dispatch_once(&once, ^{
        NSSet * productIdentifiers = [NSSet setWithObjects:
                                      @"com.leandevelop.stocklert.5alerts90days",
                                      @"com.leandevelop.stocklert.10alerts90days",
//                                      @"com.leandevelop.stocklert.10moreamoth",
//                                      @"com.leandevelop.stocklert.20moreamonth",
//                                      @"com.leandevleop.stocklert.unlimitedamonth",
                                      nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
