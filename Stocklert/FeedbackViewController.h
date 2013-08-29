//
//  FeedbackViewController.h
//  PushApp
//
//  Created by Zhenan Hong on 12/16/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UITableViewController
-(IBAction) sendFeedback;
@property (strong, nonatomic) IBOutlet UILabel *submitIndicator;
@property (strong, nonatomic) IBOutlet UITextView *feedbackField;

@end
