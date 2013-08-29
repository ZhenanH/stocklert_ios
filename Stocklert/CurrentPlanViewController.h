//
//  CurrentPlanViewController.h
//  Stocklert
//
//  Created by Zhenan Hong on 12/27/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
@interface CurrentPlanViewController : UITableViewController <MFMailComposeViewControllerDelegate,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *extensionLabel;
@property (strong, nonatomic) IBOutlet UILabel *remainingDayLabel;

-(IBAction)refreshPlan;
-(IBAction)getMoreInfo;
@end
