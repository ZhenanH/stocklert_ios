//
//  ViewController.m
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import "RulesViewController.h"
#import <Parse/Parse.h>
#import "Subscription.h"
@interface RulesViewController ()

@end

@implementation RulesViewController{
    int availableRules;
    BOOL isRest;
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        self.dataModel = [[DataModel alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    availableRules = [Subscription getAvailableRules];
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
   
    int daysleft = [Subscription getExpireDays];
    availableRules = [Subscription getAvailableRules];
    NSLog(@"day left: %d with %d rules",daysleft,availableRules);
    if(daysleft<=0){
        availableRules = 2;
        if(!isRest){
            [Subscription setSubscription:@""];
            isRest = YES;
            
        }
    }
     [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
   
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addRule
{
    if(availableRules>[self.dataModel.rulelist count])
        [self performSegueWithIdentifier:@"AddRule" sender:nil];
    else
        [self showAlert];
}



-(void)ruleDetailViewControllerDidCancel:(RuleDetailViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)doSave:(Rule *)thisRule
{
    
    [self.dataModel.rulelist addObject:thisRule];
    [self.dataModel saveRulelist];
    [self.tableView reloadData];
    
}

-(void)ruleDetailViewControllerDidSave:(RuleDetailViewController *)controller didSave:(Rule *)thisRule
{
    

    [self.dataModel.rulelist addObject:thisRule];
    [self.dataModel saveRulelist];
    [self.tableView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}



-(void)ruleDetailViewControllerDidEdit:(RuleDetailViewController *)controller didEdit:(Rule *)thisRule
{
    [self.dataModel saveRulelist];
    [self.tableView reloadData];    
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return [self.dataModel.rulelist count];
   
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RuleCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    Rule *thisRule = [self.dataModel.rulelist objectAtIndex:indexPath.row];
    NSLog(@"rule id: %@",thisRule.ruleId);
    cell.textLabel.text = thisRule.symbol;

    if([thisRule.isActive boolValue])
        cell.imageView.image = [UIImage imageNamed:@"active"];
    else
        cell.imageView.image = [UIImage imageNamed:@"inactive"];
    
    cell.detailTextLabel.text =[thisRule getPreviewWithoutSymbol];
    
    cell.textLabel.alpha = 1; 
    cell.detailTextLabel.alpha = 1;
    
    if(availableRules<indexPath.row+1){
        // cell.userInteractionEnabled = NO;
        cell.textLabel.alpha = 0.339216f; // (1 - alpha) * 255 = 143
        cell.detailTextLabel.alpha = 0.339216f;
        cell.imageView.image = [UIImage imageNamed:@"expired"];
    }

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    Rule *ruleToEdit = [self.dataModel.rulelist objectAtIndex:indexPath.row];
    
    
    if(availableRules<indexPath.row+1)
        [self showAlert];
    else
    [self performSegueWithIdentifier:@"EditRule" sender:ruleToEdit];
}


-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Rule *tobeDeleted = [self.dataModel.rulelist objectAtIndex:indexPath.row];
    if(tobeDeleted.ruleId)
        [Rule deleteRuleFromParse:tobeDeleted.ruleId];
    [self.dataModel.rulelist removeObjectAtIndex:indexPath.row];
    [self.dataModel saveRulelist];
    NSArray *indexPaths = [NSArray arrayWithObject:indexPath];
    [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"AddRule"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RuleDetailViewController *controller = (RuleDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.rule = nil;
        
    }
    
    if ([segue.identifier isEqualToString:@"EditRule"]) {
        UINavigationController *navigationController = segue.destinationViewController;
        RuleDetailViewController *controller = (RuleDetailViewController *)navigationController.topViewController;
        controller.delegate = self;
        controller.rule = sender;
    }
}

-(void)showAlert
{
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Extra Rules Expired"
                                                        message:@"Please upgrade plans to get extra rules setup"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil, nil];
    [alertView show];
    
}

@end
