//
//  ViewController.h
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RuleDetailViewController.h"
#import "DataModel.h"

@interface RulesViewController : UITableViewController <RuleDetailViewControllerDelegate>

-(IBAction)addRule;
@property (nonatomic, strong) DataModel *dataModel;

-(void)doSave:(Rule *)thisRule;
@end
