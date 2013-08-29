//
//  Stock.h
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Stock : NSObject

@property (nonatomic, copy) NSString *symbol;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *exch;

@end
