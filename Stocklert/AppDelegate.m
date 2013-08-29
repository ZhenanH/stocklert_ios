//
//  AppDelegate.m
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "Subscription.h"
#import "RulesViewController.h"
#import "RuleDetailViewController.h"
#import "Flurry.h"
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [Parse setApplicationId:@"C7i23Afdrrrr3QHwRxesHbywnBq9FyEbs2CWjMsU"
                  clientKey:@"aONQ5JV2DBdO0Nm8lSQbWmBnZcGJu5ry0nBx7B58"];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound];
    [Flurry startSession:@"89RKQ8HMSQTN3FS6B98K"];
    return YES;
}

-(void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [PFPush storeDeviceToken:deviceToken];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    PFInstallation *myInstallation = [PFInstallation currentInstallation];    
    NSString *token = [myInstallation objectForKey:@"deviceToken"];
    
    //[Subscription signUpSubscription:token];
    
    [defaults setObject:token forKey:@"deviceToken"];
     NSLog(@"token in default %@",token);
    [defaults synchronize];


    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController =[[tabBarController viewControllers] objectAtIndex:0];
    RulesViewController *rulesViewController =[[navigationController viewControllers] objectAtIndex:0];
    if([rulesViewController.dataModel.rulelist count]<=0){
        [rulesViewController.dataModel loadRulelistFromParse:rulesViewController];
    }
    
    [Subscription signUpSubscription:token forTableView:rulesViewController];
    [Subscription syncSubscription:rulesViewController];
    NSLog(@"%@",deviceToken);
}

- (void) application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Register failed!, %@",error);
}

-(void) application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo{
    NSLog(@"userInfo");
    [PFPush handlePush:userInfo];
    UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
    UINavigationController *navigationController =[[tabBarController viewControllers] objectAtIndex:0];
    
    
    
    RulesViewController *rulesViewController =[[navigationController viewControllers] objectAtIndex:0];
 
    Rule *thisRule = [[Rule alloc] init];
    thisRule.symbol = [userInfo objectForKey:@"symbol"];
    thisRule.ruleTarget = [NSString stringWithFormat:@"%@",[userInfo objectForKey:@"target"]];
    thisRule.ruleType = [userInfo objectForKey:@"type"];
    thisRule.ruleOperator = [userInfo objectForKey:@"operator"];
    thisRule.ruleId = [userInfo objectForKey:@"objectID"];
    thisRule.isActive = [[NSNumber alloc] initWithBool:NO];
    
    NSMutableArray *rules = rulesViewController.dataModel.rulelist;
    for(int i=0;i<[rules count];i++){
        
        Rule *r = rules[i];
        if([r.ruleId isEqualToString:thisRule.ruleId]){
            rulesViewController.dataModel.rulelist[i]=thisRule;
            [rulesViewController.dataModel saveRulelist];
            [rulesViewController.tableView reloadData];
        }
        
    }

    
    [rulesViewController performSegueWithIdentifier:@"EditRule" sender:thisRule];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *messages = [defaults objectForKey:@"AlertMessages"];
    messages = [NSMutableArray arrayWithArray:messages];
    
    if(!messages){
        messages = [[NSMutableArray alloc] init];
        NSDictionary *myRule  = [[NSDictionary alloc] initWithObjectsAndKeys:
                                [thisRule getPreview], @"ruleExpression",
                                 [userInfo objectForKey:@"sendingDate"],@"time", nil]; //nil to signify end of objects and keys.
        [messages addObject:myRule];
        [defaults setObject:messages forKey:@"AlertMessages"];
        [defaults synchronize];
        
    }else{
        NSDictionary *myRule  = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [thisRule getPreview], @"ruleExpression",
                                [userInfo objectForKey:@"sendingDate"],@"time", nil]; //nil to signify end of objects and keys.
        [messages addObject:myRule];
        [defaults setObject:messages forKey:@"AlertMessages"];
        [defaults synchronize];
    }

    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
