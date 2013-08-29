//
//  Rule.m
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import "Rule.h"
#import <Parse/Parse.h>
@implementation Rule


//-(id)init{
//    if((self=[super init])){
//        self.symbol = @"";
//        self.ruleTarget = @"";
//        self.ruleType = @"";
//        self.ruleId = @"";
//        self.ruleOperator = @"";
//        self.isActive = [[NSNumber alloc] initWithBool:YES];
//    }
//    return self;
//}

-(NSString*)getPreview
{
    if([self.ruleType isEqualToString:@"Set Price"])
        return [NSString stringWithFormat:@"%@ price %@ %@",self.symbol,self.ruleOperator,self.ruleTarget];
    else if([self.ruleType isEqualToString:@"Day Change(%)"])
        return [NSString stringWithFormat:@"%@ day change %@ %@ %@",self.symbol,self.ruleOperator,self.ruleTarget,@"%"];
    else
        return @"not available";
}

-(NSString*)getPreviewWithoutSymbol
{
    if([self.ruleType isEqualToString:@"Set Price"])
        return [NSString stringWithFormat:@"price %@ %@",self.ruleOperator,self.ruleTarget];
    else if([self.ruleType isEqualToString:@"Day Change(%)"])
        return [NSString stringWithFormat:@"day change %@ %@ %@",self.ruleOperator,self.ruleTarget,@"%"];
    else
        return @"not available";
}

-(NSNumber*)getTargetNumber{
    NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
    [f setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber * myNumber = [f numberFromString:self.ruleTarget];
    return myNumber;
}

+(NSArray *)getRuleOperatorsForType:(NSString*)type
{
    if([type isEqualToString:@"Set Price"]){
        NSArray* ruleOperators = [[NSArray alloc]initWithObjects:@">", @"<",nil];
        return ruleOperators;
    }else if([type isEqualToString:@"Day Change(%)"]){
        NSArray* ruleOperators = [[NSArray alloc]initWithObjects:@"+", @"-",nil];
        return ruleOperators;
    }else
        return nil;
        
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    
    if ((self = [super init])) {
        self.symbol = [aDecoder decodeObjectForKey:@"Symbol"];
        self.ruleTarget = [aDecoder decodeObjectForKey:@"RuleTarget"];
        self.ruleType = [aDecoder decodeObjectForKey:@"RuleType"];
        self.ruleId = [aDecoder decodeObjectForKey:@"RuleId"];
        self.ruleOperator = [aDecoder decodeObjectForKey:@"RuleOperator"];
        self.isActive = [aDecoder decodeObjectForKey:@"Status"];
    }
    return self;
}


- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.symbol forKey:@"Symbol"];
    [aCoder encodeObject:self.ruleTarget forKey:@"RuleTarget"];
    [aCoder encodeObject:self.ruleType forKey:@"RuleType"];
    [aCoder encodeObject:self.ruleId forKey:@"RuleId"];
    [aCoder encodeObject:self.ruleOperator forKey:@"RuleOperator"];
    [aCoder encodeObject:self.isActive forKey:@"Status"];
}

-(NSString*)getStatus
{
    if([self.isActive boolValue])
        return @"active";
    else
        return @"inactive";
}

-(NSNumber*)getStatusWithString:(NSString *)status
{
    if([status isEqualToString:@"active"])
        return [[NSNumber alloc] initWithBool:YES];
    else
        return [[NSNumber alloc] initWithBool:NO];
}

+(NSString*)getDeviceToken
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"deviceToken"];
}

+(void)updateServer
{
    
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSError *error = nil;
            NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://50.17.195.93/update"]];
            NSString *json = [NSString stringWithContentsOfURL:url
                                                      encoding:NSASCIIStringEncoding
                                                         error:&error];
            
            NSLog(@"updated server: %@",json);
            
            
        });
    
}

+(void)deleteRuleFromParse:(NSString*)deletId
{
    PFQuery *query = [PFQuery queryWithClassName:@"AlertRule"];
    [query getObjectInBackgroundWithId:deletId block:^(PFObject *thisRule, NSError *error) {
        if (!error) {
            // The get request succeeded. Log the score
            // NSLog(@"The score was: %d", [[gameScore objectForKey:@"score"] intValue]);
            NSLog(@"to be deleted %@", thisRule);
            [self updateServer];
            if(thisRule != NULL){
                [thisRule deleteInBackground];
                [PFPush unsubscribeFromChannelInBackground:[NSString stringWithFormat:@"c%@",deletId]];
            }
        } else {
            // Log details of our failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];

}
@end
