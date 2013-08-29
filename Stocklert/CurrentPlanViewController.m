//
//  CurrentPlanViewController.m
//  Stocklert
//
//  Created by Zhenan Hong on 12/27/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import "CurrentPlanViewController.h"
#import "Subscription.h"
@interface CurrentPlanViewController ()

@end

@implementation CurrentPlanViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   // NSDictionary *thisSub = [Subscription getCurrentSubscriptionFromDeafaut];
    self.extensionLabel.text = [NSString stringWithFormat:@"Extra Rules: %d", [Subscription getAvailableRules]-2];
    if([Subscription getAvailableRules]<=2 )
        self.remainingDayLabel.text = @"Not available";
    else
        self.remainingDayLabel.text = [NSString stringWithFormat:@"%d days left", [Subscription getExpireDays]];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)refreshPlan
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
                
                self.extensionLabel.text = [NSString stringWithFormat:@"Extra Rules: %d", [Subscription getAvailableRules]-2];
                if([Subscription getAvailableRules]<=2 )
                    self.remainingDayLabel.text = @"Not available";
                else
                    self.remainingDayLabel.text = [NSString stringWithFormat:@"%d days left", [Subscription getExpireDays]];
                
                NSLog(@"in sync after update day left: %d with %d rules",[Subscription getExpireDays],[Subscription getAvailableRules]);
                
            }
            else
            {}
            
        } else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            
        }
    }];
    
}

#pragma mark - Table view data source



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath isEqual:[NSIndexPath indexPathForRow:0 inSection:1]])
        [self showAlert];
}

-(void)showAlert
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Need Extension for the trial?"
                                                        message:@"Contact us to extend. We don't charge because currently in beta"
                                                       delegate:self
                                              cancelButtonTitle:@"Dismiss"
                                              otherButtonTitles:@"OK", nil];
    [alertView show];
    
}

-(IBAction)getMoreInfo
{
    [self showAlert];
}

- (void)showEmail{
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat: @"Request Extension Ticket ID: %@",[[PFInstallation currentInstallation] objectForKey:@"deviceToken"]];
    // Email Content
    NSString *messageBody = @"Please extend my trial, I would need to setup x rules";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"stocklert.help@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {
            NSLog(@"Mail sent");
            PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
            [feedback setObject:@"" forKey:@"content"];
            [feedback setObject:[[PFInstallation currentInstallation] objectForKey:@"deviceToken"] forKey:@"deviceToken"];
            
            [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                if (!error) {
                    // The gameScore saved successfully.
                    //self.submitIndicator.text = @"Sent! Thanks for your feedback";
                    
                } else {
                    // There was an error saving the gameScore.
                }
            }];
            
            break;
        }
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
    
    //close presenting view controller
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 1) {
        
        [self showEmail];        
        
    }
    
    
    
}


@end
