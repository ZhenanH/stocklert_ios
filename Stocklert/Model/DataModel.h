//
//  Rules.h
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Rule.h"

@class RulesViewController;
@interface DataModel : NSObject

@property (nonatomic, strong)NSMutableArray *rulelist;

-(void)saveRulelist;
-(void)loadRulelist;
-(void)loadRulelistFromParse:(RulesViewController*)controller;
@end
