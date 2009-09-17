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
	
	NSString *guid;
	NSInteger key;
	NSString *note;
	NSString *tags;
	double amount;
	NSInteger amount_sig;
	double latitude;
	double longitude;
	BOOL deleted;
	NSString *created_on;
	NSString *created_on_UTC;
	NSString *modified_on;
	NSString *modified_on_UTC;
	
	NSInteger activity_id;
}

@property(assign, nonatomic) TZActivity *activity;
@property(copy, nonatomic) NSString *guid;
@property(assign, nonatomic) NSInteger key;
@property(copy, nonatomic) NSString *note;
@property(copy, nonatomic) NSString *tags;
@property(assign, nonatomic) double amount;
@property(assign, nonatomic) NSInteger amount_sig;
@property(assign, nonatomic) double latitude;
@property(assign, nonatomic) double longitude;
@property(assign, nonatomic) BOOL deleted;
@property(copy, nonatomic) NSString *created_on;
@property(copy, nonatomic) NSString *created_on_UTC;
@property(copy, nonatomic) NSString *modified_on;
@property(copy, nonatomic) NSString *modified_on_UTC;
@property(assign, nonatomic) NSInteger activity_id;

- (id)initWithKey:(int)key andActivity:(TZActivity *)activity;
- (id)initWithGUID:(NSString *)guid andActivity:(TZActivity *)activity;
- (BOOL)save;
- (BOOL)saveRaw;

@end
