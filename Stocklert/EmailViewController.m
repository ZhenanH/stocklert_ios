//
//  EmailViewController.m
//  Stocklert
//
//  Created by Zhenan Hong on 1/26/13.
//  Copyright (c) 2013 Lean Develop. All rights reserved.
//

#import "EmailViewController.h"
#import <Parse/Parse.h>
@interface EmailViewController ()

@end

@implementation EmailViewController{
   // NSString *feedbackField;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    [self showEmail];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)showEmail{
    // Email Subject
    NSString *emailTitle = [NSString stringWithFormat: @"Feedback & Questions Ticket ID: %@",[[PFInstallation currentInstallation] objectForKey:@"deviceToken"]];
    // Email Content
    NSString *messageBody = @" ";
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
@end
