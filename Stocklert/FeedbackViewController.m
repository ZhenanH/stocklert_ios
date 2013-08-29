//
//  FeedbackViewController.m
//  PushApp
//
//  Created by Zhenan Hong on 12/16/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import "FeedbackViewController.h"
#import <Parse/Parse.h>
@interface FeedbackViewController ()

@end

@implementation FeedbackViewController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    
  
}

-(IBAction) sendFeedback
{
    if([self.feedbackField.text isEqualToString:@""]){
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Forgot to write something?"
                                                            message:@"Please put down some words so we can assist you"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
        
    

}else{
    self.submitIndicator.text = @"";
    [self.feedbackField endEditing:YES];
    PFObject *feedback = [PFObject objectWithClassName:@"Feedback"];
    [feedback setObject:self.feedbackField.text forKey:@"content"];
    [feedback setObject:[[PFInstallation currentInstallation] objectForKey:@"deviceToken"] forKey:@"deviceToken"];
    
    [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // The gameScore saved successfully.
             self.submitIndicator.text = @"Sent! Thanks for your feedback";
            
        } else {
            // There was an error saving the gameScore.
        }
    }];
   
}
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==1) {
        [self sendFeedback];
    }}

@end
