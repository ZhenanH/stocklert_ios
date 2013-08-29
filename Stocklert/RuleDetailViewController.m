//
//  RuleDetailViewController.m
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import "RuleDetailViewController.h"
#import "SearchViewController.h"
#import <Parse/Parse.h>
@interface RuleDetailViewController ()

@end

@implementation RuleDetailViewController{
    int pickerViewItemCount;
    NSArray *ruleTypes;
    NSArray *ruleOperators;
    UIPickerView *typePickerView;
    UIPickerView *operatorPickerView1;
    UIPickerView *operatorPickerView2;
    NSString *change;
    NSString *percentage;
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
    self.livePriceLabel.hidden = YES;
    self.liveChangeButton.hidden = YES;
    self.loadingIndicator.hidden = YES;
    [self.loadingIndicator startAnimating];
    //[self.liveCell setBackgroundColor:[UIColor colorWithRed:4.0/255 green:57.0/255 blue:74.0/255 alpha:1.0]];
     [self.livePriceLabel setHidden:YES];
     [self.liveChangeButton setHidden:YES];
    if(self.rule){
         self.loadingIndicator.hidden = NO;
        self.title = @"Edit Rule";
        self.liveSymbol.text = self.rule.symbol;
        self.ruleTypeField.text=self.rule.ruleType;
        self.ruleTargetField.text = self.rule.ruleTarget;
        self.ruleOperatorField.text = self.rule.ruleOperator;
        self.statusSwitch.on = [self.rule.isActive boolValue];
        //self.previewLabel.text = [self.rule getPreview];
        [self.livePriceLabel setHidden:NO];
        [self.liveChangeButton setHidden:NO];
    }else{
        self.ruleTypeField.text = @"Set Price";
        self.ruleOperatorField.text = @">";
    }
    self.ruleTypeField.delegate = self;
    self.ruleOperatorField.delegate = self;
    ruleTypes = [[NSArray alloc]initWithObjects:@"Set Price", @"Day Change(%)",nil];
    ruleOperators = [Rule getRuleOperatorsForType:self.ruleTypeField.text];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(![self.liveSymbol.text isEqualToString:@"Search Symbol"]){
        [self loadLiveQuote];
        [self.livePriceLabel setHidden:NO];
        [self.liveChangeButton setHidden:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)cancel
{
    [self.delegate ruleDetailViewControllerDidCancel:self];
}

-(IBAction)done
{
    if([self.liveSymbol.text isEqualToString:@"Search Symbol"]||[self.ruleOperatorField.text isEqualToString:@""]||[self.ruleTargetField.text isEqualToString:@""]){
        [self showAlert];
    }else{
    if(self.rule==nil){
    self.rule = [[Rule alloc]init];
    self.rule.symbol = self.liveSymbol.text;
    self.rule.ruleOperator = self.ruleOperatorField.text;
    self.rule.ruleTarget = self.ruleTargetField.text;
    self.rule.ruleType = self.ruleTypeField.text;
    self.rule.isActive = [NSNumber numberWithBool: self.statusSwitch.isOn];
       
        
        //creat rules save to parse
        PFObject *alertRule = [PFObject objectWithClassName:@"AlertRule"];
        [alertRule setObject:self.rule.symbol forKey:@"stockSymbol"];
        [alertRule setObject:self.rule.ruleType forKey:@"ruleType"];
        [alertRule setObject:[self.rule getTargetNumber] forKey:@"ruleTarget"];
        [alertRule setObject:self.rule.ruleOperator forKey:@"ruleOperator"];
        [alertRule setObject:[Rule getDeviceToken] forKey:@"deviceToken"];
        [alertRule setObject:[self.rule getStatus] forKey:@"alertStatus"];
        [alertRule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [Rule updateServer];
                NSString *objectId = alertRule.objectId;
                self.rule.ruleId = objectId;
                [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"c%@",self.rule.ruleId]];
                NSLog(@"update successfully");
            } else {
                NSLog(@"error");
            }
        }];

         [self.delegate ruleDetailViewControllerDidSave:self didSave:self.rule];
        

        
    
    }else{
        self.rule.symbol = self.liveSymbol.text;
        self.rule.ruleOperator = self.ruleOperatorField.text;
        self.rule.ruleTarget = self.ruleTargetField.text;
        self.rule.ruleType = self.ruleTypeField.text;
        self.rule.isActive = [NSNumber numberWithBool: self.statusSwitch.isOn];
       
        
        //update rule on parse
        PFQuery *query = [PFQuery queryWithClassName:@"AlertRule"];
        PFObject *alertRule = [query getObjectWithId:self.rule.ruleId];
        [alertRule setObject:self.rule.symbol forKey:@"stockSymbol"];
        [alertRule setObject:self.rule.ruleType forKey:@"ruleType"];
        [alertRule setObject:[self.rule getTargetNumber] forKey:@"ruleTarget"];
        [alertRule setObject:self.rule.ruleOperator forKey:@"ruleOperator"];
        [alertRule setObject:[Rule getDeviceToken] forKey:@"deviceToken"];
        [alertRule setObject:[self.rule getStatus] forKey:@"alertStatus"];
        
        [alertRule saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {

                [Rule updateServer];
                [PFPush subscribeToChannelInBackground:[NSString stringWithFormat:@"c%@",self.rule.ruleId]];
                NSLog(@"update successfully");
            } else {
              
                NSLog(@"error");
            }
        }];
         [self.delegate ruleDetailViewControllerDidEdit:self didEdit:self.rule];
    }
    }
}

-(void)showAlert
{
   
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Fields cannot be blank"
                                                            message:@"Please fill in something"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil, nil];
        [alertView show];
    
}

-(IBAction)toggleChange
{
   if([self.liveChangeButton.titleLabel.text isEqualToString:change])
       [self.liveChangeButton setTitle:percentage forState:UIControlStateNormal];
    else
       [self.liveChangeButton setTitle:change forState:UIControlStateNormal];
}

#pragma mark - Table view delegate



-(void)searchViewController:(SearchViewController *)controller didPickSymbol:(NSString *)symbolName
{
    self.liveSymbol.text = symbolName;
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"Search"]) {
        SearchViewController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if(textField==self.ruleTypeField){
        typePickerView = [[UIPickerView alloc] init];
        [typePickerView sizeToFit];
        typePickerView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        typePickerView.delegate = self;
        typePickerView.dataSource = self;
        typePickerView.showsSelectionIndicator = YES;
        textField.inputView = typePickerView;
        pickerViewItemCount = [ruleTypes count];
    }
    else if(textField == self.ruleOperatorField){
        operatorPickerView1 = [[UIPickerView alloc] init];
        [operatorPickerView1 sizeToFit];
        operatorPickerView1.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        operatorPickerView1.delegate = self;
        operatorPickerView1.dataSource = self;
        operatorPickerView1.showsSelectionIndicator = YES;
        textField.inputView = operatorPickerView1;
        pickerViewItemCount = [ruleOperators count];
    }
    return YES;
    
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerViewItemCount;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView==typePickerView){
        self.ruleTypeField.text=[ruleTypes objectAtIndex:row];
        ruleOperators = [Rule getRuleOperatorsForType:self.ruleTypeField.text];
        self.ruleOperatorField.text = @"";
        [self.ruleTypeField endEditing:YES];
    }
    if(pickerView==operatorPickerView1){
    self.ruleOperatorField.text=[ruleOperators objectAtIndex:row];
        [self.ruleOperatorField endEditing:YES];
    }
    
    //[pickerView removeFromSuperview];
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if(pickerView==typePickerView){
        return [ruleTypes objectAtIndex:row];
    }
    if(pickerView==operatorPickerView1){
        return [ruleOperators objectAtIndex:row];
    }
    
    else return @"not available";
    [pickerView removeFromSuperview];
}

-(void) loadLiveQuote {
    self.livePriceLabel.hidden = YES;
    self.liveChangeButton.hidden = YES;
    self.loadingIndicator.hidden = NO;
    //get live quote
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSError *error = nil;
        
        
        NSString *financeUrl = [NSString stringWithFormat:@"http://download.finance.yahoo.com/d/quotes.csv?s=%@&f=sl1d1t1c1p2ohgv&e=.csv",self.liveSymbol.text];
        NSString *csvPara = [NSString stringWithFormat:@"symbol,price,date,time,change,percentage,col1,high,low,col2"];
        NSString *mainUrl = [@"http://query.yahooapis.com/v1/public/yql?q=select * from csv where url" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *updateUrl = [NSString stringWithFormat:@"%@='%@'%@columns='%@'%@format=json" ,mainUrl,[self urlEncoded:financeUrl],@"%20and%20",[self urlEncoded:csvPara],@"%20&"] ;
        
        NSURL *url = [NSURL URLWithString:updateUrl];
        NSString *json = [NSString stringWithContentsOfURL:url
                                                  encoding:NSASCIIStringEncoding
                                                     error:&error];
        
        
        NSData *jsonData = [json dataUsingEncoding:NSASCIIStringEncoding];
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData
                                                                 options:kNilOptions
                                                                   error:&error];
        NSDictionary *jsonResults = [[[jsonDict objectForKey:@"query"] objectForKey:@"results"] objectForKey:@"row"];
        NSLog(@"%@",jsonResults);
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[self.searchDisplayController.searchResultsTableView reloadData];
            NSString * currentPrice = [jsonResults objectForKey:@"price"];
            change = [jsonResults objectForKey:@"change"];
            percentage = [jsonResults objectForKey:@"percentage"];
            
            
            self.livePriceLabel.text = currentPrice;
            [self.liveChangeButton setTitle:percentage forState:UIControlStateNormal];
            
            if([change floatValue]>0)
               [self.liveChangeButton setBackgroundImage:[UIImage imageNamed:@"green"] forState:UIControlStateNormal];
            else
                [self.liveChangeButton setBackgroundImage:[UIImage imageNamed:@"red"] forState:UIControlStateNormal];

            self.livePriceLabel.hidden = NO;
            self.liveChangeButton.hidden = NO;
            self.loadingIndicator.hidden = YES;
            NSLog(@"reloaded");
        });
    });
    //end get quote
    
}

-(NSString *) urlEncoded:(NSString*) s
{
    CFStringRef urlString = CFURLCreateStringByAddingPercentEscapes(
                                                                    NULL,
                                                                    (CFStringRef)s,
                                                                    NULL,
                                                                    (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                                    kCFStringEncodingUTF8 );
    return [NSString stringWithFormat:@"%@", urlString] ;
}

- (void)viewDidUnload {
    [self setLoadingIndicator:nil];
    [super viewDidUnload];
}
@end
