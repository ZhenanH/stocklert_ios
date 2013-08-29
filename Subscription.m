//
//  Subscription.m
//  PushApp
//
//  Created by Zhenan Hong on 12/14/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import "Subscription.h"
#import <Parse/Parse.h>
@implementation Subscription

+(void)setSubscription:(NSString*)productID
{
    NSLog(@"updating subscriptions");
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    if(![defaults objectForKey:@"Subscription"]){
    NSNumber *ruleCount = [[NSNumber alloc] initWithInt:2];
    NSNumber *remainingDays = [[NSNumber alloc] initWithInt:-1];
    NSDictionary *subscription = [[NSDictionary alloc]initWithObjectsAndKeys:
                                  @"Original Plan",  @"name", ruleCount, @"rules",remainingDays,@"remainingDays",productID,@"productID", nil];
    [defaults setObject:subscription forKey:@"Subscription"];
        [defaults synchronize];
    }
    
   __block NSNumber *currentCount = [[defaults objectForKey:@"Subscription"] objectForKey:@"rules"];
    __block NSNumber *remainingDays = [[defaults objectForKey:@"Subscription"] objectForKey:@"remainingDays"];
  
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    if(!deviceToken)
        return;
        
    PFQuery *query = [PFQuery queryWithClassName:@"Subscription"];
    [query whereKey:@"deviceToken" equalTo:deviceToken];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d subscriptions in set.", objects.count);
            if(objects.count>0)
            {
                PFObject* subObj = objects[0];
                if([productID isEqualToString:@"com.leandevelop.stocklert.5alerts90days"]){
                    
                    
                    currentCount = [NSNumber numberWithInt:[currentCount intValue]+5];
                    NSLog(@"expire at: %@",[Subscription getExpireDate:90]);
                    remainingDays = [NSNumber numberWithInt:[remainingDays intValue]+1+[Subscription daysWithinEraFromDate:[Subscription getExpireDate:90] toDate:[NSDate date]]];
                    NSDictionary *subscription = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                  @"5alerts90days",  @"name", currentCount, @"rules",remainingDays,@"remainingDays",productID,@"productID",[Subscription getExpireDate:90],@"expireDate", nil];
                    
                    [defaults setObject:subscription forKey:@"Subscription"];
                    [defaults synchronize];
                    [subObj setObject:subscription forKey:@"Subscription"];
                    [subObj saveInBackground];
                }else if([productID isEqualToString:@"com.leandevelop.stocklert.10alerts90days"]){
                    
                    currentCount = [NSNumber numberWithInt:[currentCount intValue]+10];
                    remainingDays = [NSNumber numberWithInt:[remainingDays intValue]+1+[Subscription daysWithinEraFromDate:[Subscription getExpireDate:90] toDate:[NSDate date]]];
                    NSDictionary *subscription = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                  @"10alerts90days",  @"name", currentCount, @"rules",remainingDays,@"remainingDays",productID,@"productID",[Subscription getExpireDate:90],@"expireDate", nil];
                    
                    [defaults setObject:subscription forKey:@"Subscription"];
                    [defaults synchronize];
                    [subObj setObject:subscription forKey:@"Subscription"];
                    [subObj saveInBackground];
                }else if([productID isEqualToString:@""]){
                    
                    NSNumber *ruleCount = [[NSNumber alloc] initWithInt:2];
                    NSNumber *remainingDays = [[NSNumber alloc] initWithInt:-1];
                    NSDictionary *subscription = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                  @"Original Plan",  @"name", ruleCount, @"rules",remainingDays,@"remainingDays",productID,@"productID",[Subscription getExpireDate:-1],@"expireDate", nil];
                    [defaults setObject:subscription forKey:@"Subscription"];
                    [defaults synchronize];
                    [subObj setObject:subscription forKey:@"Subscription"];
                    [subObj saveInBackground];
                }else if([productID isEqualToString:@"trail"]){
                    
                    NSNumber *ruleCount = [[NSNumber alloc] initWithInt:10];
                    NSNumber *remainingDays = [[NSNumber alloc] initWithInt:30];
                    NSDictionary *subscription = [[NSDictionary alloc]initWithObjectsAndKeys:
                                                  @"Original Plan",  @"name", ruleCount, @"rules",remainingDays,@"remainingDays",productID,@"productID",[Subscription getExpireDate:30],@"expireDate", nil];
                    [defaults setObject:subscription forKey:@"Subscription"];
                    [defaults synchronize];
                    [subObj setObject:subscription forKey:@"Subscription"];
                    [subObj saveInBackground];
                }
                

            }
            else
            {}
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
   
    
   
    
        
    
    
}

-(void)setTransaction: (SKPaymentTransaction *)transaction
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:transaction forKey:@"Transaction"];
}

+(NSDictionary*)getCurrentSubscriptionFromDeafaut
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"Subscription"];
}

+(void)syncSubscription:(UITableViewController *)controller
{
   NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    PFQuery *query = [PFQuery queryWithClassName:@"Subscription"];
    [query whereKey:@"deviceToken" equalTo:deviceToken];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d subscriptions in sync.", objects.count);
            if(objects.count>0)
            {
                [defaults setObject:[objects[0] objectForKey:@"Subscription"]forKey:@"Subscription"];
                [defaults synchronize];
                [controller.tableView reloadData];
                NSLog(@"in sync day left: %d with %d rules",[Subscription getExpireDays],[Subscription getAvailableRules]);

            }
            else
            {}
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];

}

+(NSDate*)getExpireDate:(int)extension
{
    // How much day to add
    int addDaysCount = extension;
        
    // Retrieve NSDate instance from stringified date presentation
    NSDate *dateFromString = [NSDate date];
    
    // Create and initialize date component instance
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:addDaysCount];
    
    // Retrieve date with increased days count
    NSDate *newDate = [[NSCalendar currentCalendar]
                       dateByAddingComponents:dateComponents
                       toDate:dateFromString options:0];
    
    return newDate;
}


+(NSInteger)daysWithinEraFromDate:(NSDate *) startDate toDate:(NSDate *) endDate
{
    NSCalendar *myCal = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger startDay=[myCal ordinalityOfUnit:NSDayCalendarUnit
                                        inUnit: NSEraCalendarUnit forDate:startDate];
    NSInteger endDay=[myCal ordinalityOfUnit:NSDayCalendarUnit
                                      inUnit: NSEraCalendarUnit forDate:endDate];
    return startDay-endDay;
}

+(void)signUpSubscription: (NSString* )deviceToken forTableView:(UITableViewController*) controller
{
        
    PFQuery *query = [PFQuery queryWithClassName:@"Subscription"];
    [query whereKey:@"deviceToken" equalTo:deviceToken];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d subscriptions in sign up.", objects.count);
            if(objects.count>0){
            }                
            else
            {
                PFObject *subscription = [PFObject objectWithClassName:@"Subscription"];
                [subscription setObject:deviceToken forKey:@"deviceToken"];
                [subscription save];
                [Subscription setSubscription:@"trail"];
                [Subscription setUpSample:deviceToken forTableView:controller];
            }
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
           
        }
    }];
    
}

+(int)getExpireDays
{
    int leftDays;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"Subscription"]){
    NSDate *expDay = [[defaults objectForKey:@"Subscription"] objectForKey:@"expireDate"];
    if(expDay){
    leftDays = [Subscription daysWithinEraFromDate:expDay toDate:[NSDate date]];
        return leftDays;
    }else
        return -1;
    }
    else return -1;
}

+(int)getAvailableRules
{
    int availableRules = 2;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"Subscription"])
    availableRules = [[[defaults objectForKey:@"Subscription"] objectForKey:@"rules"] intValue];
    return availableRules;
}

+(void)setUpSample:(NSString*)deviceToken forTableView:(UITableViewController*) controller
{
    RulesViewController *rc =(RulesViewController*)controller;
        Rule *sampleRule = [[Rule alloc]init];
        sampleRule.symbol = @"AAPL";
        sampleRule.ruleOperator = @">";
        sampleRule.ruleTarget = @"400";
        sampleRule.ruleType = @"Set Price";
        sampleRule.isActive = [NSNumber numberWithBool: YES];
        
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    
        //creat rules save to parse
        PFObject *alertRule = [PFObject objectWithClassName:@"AlertRule"];
        [alertRule setObject:@"AAPL" forKey:@"stockSymbol"];
        [alertRule setObject:@"Set Price" forKey:@"ruleType"];
        [alertRule setObject:[f numberFromString:@"400"] forKey:@"ruleTarget"];
        [alertRule setObject:@">" forKey:@"ruleOperator"];
        [alertRule setObject:deviceToken forKey:@"deviceToken"];
        [alertRule setObject:@"active" forKey:@"alertStatus"];
        [alertRule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [Rule updateServer];
                NSString *objectId = alertRule.objectId;
                sampleRule.ruleId = objectId;
                [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"c%@",sampleRule.ruleId]];
                NSLog(@"update successfully");
            } else {
                NSLog(@"error");
            }
        }];
        
        [rc doSave:sampleRule];
}

@end
