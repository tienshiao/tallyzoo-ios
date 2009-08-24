//
//  TZCount.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZActivity.h"

@interface TZCount : NSObject {
	TZActivity *activity;
	
	NSInteger key;
	NSString *note;
	NSString *tags;
	double amount;
	int	amount_sig;
	double latitude;
	double longitude;
	BOOL deleted;
	NSString *created_on;
}

@property(assign, nonatomic) TZActivity *activity;
@property(assign, nonatomic) NSInteger key;
@property(copy, nonatomic) NSString *note;
@property(copy, nonatomic) NSString *tags;
@property(assign, nonatomic) double amount;
@property(assign, nonatomic) int amount_sig;
@property(assign, nonatomic) double latitude;
@property(assign, nonatomic) double longitude;
@property(assign, nonatomic) BOOL deleted;
@property(copy, nonatomic) NSString *created_on;

- (id)initWithKey:(int)key andActivity:(TZActivity *)key;
- (BOOL)save;

@end
