//
//  Rules.m
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import "DataModel.h"
#import "Rule.h"
#import <Parse/Parse.h>
#import "RulesViewController.h"

@implementation DataModel

-(id)init
{
    if((self=[super init])){
        [self loadRulelist];
       
    }
    return  self;
}

- (NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

- (NSString *)dataFilePath
{
    return [[self documentsDirectory] stringByAppendingPathComponent:@"Rulelist.plist"];
}

- (void)saveRulelist
{
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.rulelist forKey:@"RuleList"];
    [archiver finishEncoding];
    [data writeToFile:[self dataFilePath] atomically:YES];
   
}

- (void)loadRulelist
{
    NSString *path = [self dataFilePath];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.rulelist = [unarchiver decodeObjectForKey:@"RuleList"];
        [unarchiver finishDecoding];
    } else {
        self.rulelist = [[NSMutableArray alloc] initWithCapacity:20];
        
    }
    
}

-(void)loadRulelistFromParse:(RulesViewController*)controller
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *deviceToken = [defaults objectForKey:@"deviceToken"];
    
    PFQuery *query = [PFQuery queryWithClassName:@"AlertRule"];
    [query whereKey:@"deviceToken" equalTo:deviceToken];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // The find succeeded.
            NSLog(@"Successfully retrieved %d scores.", objects.count);
            // NSLog(@"rule object %@", self.rules);
            for(int i =0;i<objects.count;i++){
                Rule *thisRule = [[Rule alloc] init];
                thisRule.symbol = [objects[i] objectForKey:@"stockSymbol"];
                thisRule.ruleTarget = [NSString stringWithFormat:@"%@",[objects[i] objectForKey:@"ruleTarget"]];
                thisRule.ruleType = [objects[i] objectForKey:@"ruleType"];
                thisRule.ruleOperator = [objects[i] objectForKey:@"ruleOperator"];
                PFObject *alertObj = objects[i];
                thisRule.ruleId = alertObj.objectId;
                NSLog(@"rule id: %@",thisRule.ruleId);
                thisRule.isActive = [thisRule getStatusWithString: [objects[i] objectForKey:@"alertStatus"]];
                
                
               
                // NSLog(@"...%@",TP.objectId);
                
                [self.rulelist addObject:thisRule];
                
            }
            
            [controller.tableView reloadData];
            
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
    
}


@end
