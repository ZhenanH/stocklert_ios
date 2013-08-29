//
//  AlertViewController.m
//  PushApp
//
//  Created by Zhenan Hong on 12/12/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import "AlertViewController.h"
#import "Rule.h"
@interface AlertViewController ()

@end

@implementation AlertViewController
@synthesize alertMessages;
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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
   
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    alertMessages = [NSMutableArray arrayWithArray:[defaults objectForKey:@"AlertMessages"]];
    
    [self.tableView reloadData];
    //NSLog(@"alert messages: %@",alertMessages);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return [alertMessages count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"AlertCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    NSDictionary *rule = [alertMessages objectAtIndex:[alertMessages count]-indexPath.row - 1];
    cell.textLabel.text = [rule objectForKey:@"ruleExpression"];
    cell.detailTextLabel.text = [rule objectForKey:@"time"];
    cell.imageView.image = [UIImage imageNamed:@"msg"];
    // Configure the cell...
    
    return cell;
}




// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        
        [alertMessages removeObjectAtIndex:[alertMessages count]-indexPath.row - 1];
        //[self.tableView reloadData];
         NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:alertMessages forKey:@"AlertMessages"];
        [defaults synchronize];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
