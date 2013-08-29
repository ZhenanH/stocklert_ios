//
//  SearchViewController.h
//  StockSearch
//
//  Created by Zhenan Hong on 12/2/12.
//  Copyright (c) 2012 Zhenan Hong. All rights reserved.
//

#import <UIKit/UIKit.h>

#define searchQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1
#define searchURL [NSURL URLWithString: @"http://d.yimg.com/autoc.finance.yahoo.com/autoc?query=y&callback=YAHOO.Finance.SymbolSuggest.ssCallback"]

@class SearchViewController;

@protocol SearchViewControllerDelegate <NSObject>

- (void)searchViewController:
(SearchViewController *)controller
               didPickSymbol:(NSString *)symbolName;

@end


@interface SearchViewController : UITableViewController

@property (nonatomic,weak) id <SearchViewControllerDelegate> delegate;
@property (nonatomic,strong) NSString *symbolName;
@property (nonatomic, strong) NSMutableArray *stocks;
@end

