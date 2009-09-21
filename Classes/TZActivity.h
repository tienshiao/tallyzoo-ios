//
//  TZItem.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TZActivity : NSObject {
	NSString *guid;
	NSInteger key;
	NSString *name;
	NSString *default_note;
	NSString *default_tags;
	double initial_value;
	int init_sig;
	double default_step;
	int step_sig;
	UIColor *color;
	BOOL public;
	int count_updown;
	int display_total;
	int screen;
	int position;
	BOOL deleted;
	NSString *created_on;
	NSString *created_on_UTC;
	NSString *modified_on;
	NSString *modified_on_UTC;
	
	NSMutableArray *counts;
	NSNumberFormatter *formatter;
}

@property(copy, nonatomic) NSString *guid;
@property(assign, nonatomic) NSInteger key;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *default_note;
@property(copy, nonatomic) NSString *default_tags;
@property(assign, nonatomic) double initial_value;
@property(assign, nonatomic) int init_sig;
@property(assign, nonatomic) double default_step;
@property(assign, nonatomic) int step_sig;
@property(nonatomic, retain) UIColor *color;
@property(assign, nonatomic) BOOL public;
@property(assign, nonatomic) int count_updown;
@property(assign, nonatomic) int display_total;
@property(assign, nonatomic) int screen;
@property(assign, nonatomic) int position;
@property(assign, nonatomic) BOOL deleted;
@property(copy, nonatomic) NSString *created_on;
@property(copy, nonatomic) NSString *created_on_UTC;
@property(copy, nonatomic) NSString *modified_on;
@property(copy, nonatomic) NSString *modified_on_UTC;
@property(nonatomic, readonly) NSMutableArray *counts;

+ (BOOL)nameExists:(NSString *)n;
- (id)initWithKey:(NSInteger)k;
- (id)initWithGUID:(NSString *)guid;
- (id)initWithName:(NSString *)name;
- (BOOL)save;
- (BOOL)saveRaw;
- (void)loadCounts;
- (void)simpleCount;
- (NSString *)sum;


#define BADGE_OFF 0
#define BADGE_ALL 1
#define BADGE_DAY 2
#define BADGE_WEEK 3
#define BADGE_MONTH 4

@end
