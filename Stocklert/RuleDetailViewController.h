//
//  RuleDetailViewController.h
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Rule.h"
#import "SearchViewController.h"
@class RuleDetailViewController;

@protocol RuleDetailViewControllerDelegate <NSObject>

-(void)ruleDetailViewControllerDidCancel:(RuleDetailViewController*) controller;
-(void)ruleDetailViewControllerDidSave:(RuleDetailViewController *)controller didSave:(Rule*)thisRule;
-(void)ruleDetailViewControllerDidEdit:(RuleDetailViewController *)controller didEdit:(Rule*)thisRule;

@end

@interface RuleDetailViewController : UITableViewController<SearchViewControllerDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UITextFieldDelegate>

@property id <RuleDetailViewControllerDelegate> delegate;
-(IBAction)cancel;
-(IBAction)done;
-(IBAction)toggleChange;
@property (nonatomic, strong) Rule* rule;




@property (strong, nonatomic) IBOutlet UITextField *ruleTypeField;
@property (strong, nonatomic) IBOutlet UITextField *ruleOperatorField;
@property (strong, nonatomic) IBOutlet UITextField *ruleTargetField;
@property (strong, nonatomic) IBOutlet UILabel *previewLabel;
@property (strong, nonatomic) IBOutlet UISwitch *statusSwitch;

@property (strong, nonatomic) IBOutlet UILabel *livePriceLabel;
@property (strong, nonatomic) IBOutlet UIButton *liveChangeButton;
@property (strong, nonatomic) IBOutlet UILabel *liveSymbol;
@property (strong, nonatomic) IBOutlet UITableViewCell *liveCell;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *loadingIndicator;


@end
