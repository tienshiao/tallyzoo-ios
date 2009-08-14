//
//  TZItem.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TZActivity : NSObject {
	NSInteger key;
	NSString *name;
	NSString *default_note;
	NSString *default_tags;
	double initial_value;
	double default_step;
	UIColor *color;
	BOOL public;
	int count_updown;
	BOOL display_total;
	int screen;
	int position;
	BOOL deleted;
	NSString *created_on;
	
	NSMutableArray *counts;
}

@property(assign, nonatomic) NSInteger key;
@property(copy, nonatomic) NSString *name;
@property(copy, nonatomic) NSString *default_note;
@property(copy, nonatomic) NSString *default_tags;
@property(assign, nonatomic) double initial_value;
@property(assign, nonatomic) double default_step;
@property(nonatomic, retain) UIColor *color;
@property(assign, nonatomic) BOOL public;
@property(assign, nonatomic) int count_updown;
@property(assign, nonatomic) BOOL display_total;
@property(assign, nonatomic) int screen;
@property(assign, nonatomic) int position;
@property(assign, nonatomic) BOOL deleted;
@property(copy, nonatomic) NSString *created_on;

-(id)initWithKey:(NSInteger)k;
-(BOOL)save;
-(void)loadCounts;
-(void)simpleCount;

@end
