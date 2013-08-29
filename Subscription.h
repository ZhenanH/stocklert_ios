//
//  Subscription.h
//  PushApp
//
//  Created by Zhenan Hong on 12/14/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import <Parse/Parse.h>
#import "RulesViewController.h"
@interface Subscription : NSObject

@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSDate *startingTime;
@property (nonatomic,strong) NSDate *endingTime;
@property  NSInteger rules;

+(void)setSubscription:(NSString*)productID;
-(void)setTransaction: (SKPaymentTransaction *)transaction;
+(NSDictionary*)getCurrentSubscriptionFromDeafaut;
+(void)syncSubscription:(RulesViewController *)controller;
+(NSDate*)getExpireDate:(int)extension;
+(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate;
+(void)signUpSubscription: (NSString* )deviceToken forTableView:(UITableViewController*) controller ;
+(int)getExpireDays;
+(int)getAvailableRules;

@end
