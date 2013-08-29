//
//  SearchViewController.m
//  StockSearch
//
//  Created by Zhenan Hong on 12/2/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import "SearchViewController.h"
#import "Stock.h"
@interface SearchViewController ()

@end

@implementation SearchViewController{
    
        NSArray *searchSourse;
        NSArray *searchResults;
       

}

@synthesize delegate;
@synthesize symbolName;


- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
   
    NSLog(@"search key: %@",searchText);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat: @"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=%@&callback=YAHOO.Finance.SymbolSuggest.ssCallback",searchText]];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        if(json!=nil){
        NSString *parsedJson = [ [json stringByReplacingOccurrencesOfString:@"YAHOO.Finance.SymbolSuggest.ssCallback(" withString:@""] stringByReplacingOccurrencesOfString:@")" withString:@""];
        
        NSData *jsonData = [parsedJson dataUsingEncoding:NSASCIIStringEncoding];
            if(jsonData!=nil){
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:kNilOptions
                                                                   error:&error];
        NSArray *jsonResults = [[jsonDict objectForKey:@"ResultSet"] objectForKey:@"Result"];
        self.stocks =[[NSMutableArray alloc] init];
         //NSLog(@"json results: %@",jsonResults);
        for(int i=0;i<[jsonResults count];i++){
            Stock *stock = [[Stock alloc] init];
            stock.name = [jsonResults[i] objectForKey:@"name"];
            stock.symbol = [jsonResults[i] objectForKey:@"symbol"];
            stock.exch = [jsonResults[i] objectForKey:@"exch"];
            //NSLog(@"stock: %@",stock.name);
            [self.stocks addObject:stock];
        }
        //searchResults = [symbols filteredArrayUsingPredicate:resultPredicate];
        searchResults = self.stocks;
       
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.searchDisplayController.searchResultsTableView reloadData];
            NSLog(@"reloaded");
        });
            }//if
        }
    });
    
    //searchResults = [searchSourse filteredArrayUsingPredicate:resultPredicate];
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    unichar c;

    if ([searchString length]>0)
    {
        c = [searchString characterAtIndex:0];
    }
    
    if ([[NSCharacterSet letterCharacterSet] characterIsMember:c] ||
        [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c]){
        
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];

    }
    return YES;
}



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
    self.stocks = [[NSMutableArray alloc] init];
    
    searchSourse =[[NSArray alloc] init];
    

    
}






- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [searchSourse count];
        
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"Result";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:simpleTableIdentifier];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        Stock *stock = [searchResults objectAtIndex:indexPath.row];
        cell.textLabel.text = stock.symbol;
        cell.detailTextLabel.text =[NSString stringWithFormat:@" %@ (%@)",stock.name,stock.exch];
        
        
         // NSLog(@"display %@", cell.textLabel.text);
    } else {
        cell.textLabel.text = [searchSourse objectAtIndex:indexPath.row];
    }
  
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        //[self performSegueWithIdentifier: @"showRecipeDetail" sender: self];
       
        indexPath = [self.searchDisplayController.searchResultsTableView indexPathForSelectedRow];
        Stock *s = [searchResults objectAtIndex:indexPath.row];
         [self.delegate searchViewController:self didPickSymbol:s.symbol];
    }
}

@end
