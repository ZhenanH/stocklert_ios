//
//  Rule.h
//  Stocklert
//
//  Created by Zhenan Hong on 12/22/12.
//  Copyright (c) 2012 Lean Develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rule : NSObject<NSCoding>

@property (nonatomic, strong) NSString *symbol;
@property (nonatomic, strong) NSString *ruleType;
@property (nonatomic, strong) NSString *ruleOperator;
@property (nonatomic, strong) NSString *ruleTarget;
@property (nonatomic, strong) NSNumber *isActive;
@property (nonatomic, strong) NSString *ruleId;


-(NSString*)getPreview;
-(NSString*)getPreviewWithoutSymbol;
-(NSNumber*)getTargetNumber;
-(NSString*)getStatus;
+(NSArray*)getRuleOperatorsForType:(NSString*)type;
+(NSString*)getDeviceToken;
+(void)updateServer;
+(void)deleteRuleFromParse:(NSString*)deletId;
-(NSNumber*)getStatusWithString:(NSString *)status;
@end
