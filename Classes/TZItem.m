//
//  TZItem.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TZItem.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"

@implementation TZItem

@synthesize key;
@synthesize name;
@synthesize default_note;
@synthesize default_tags;
@synthesize initial_value;
@synthesize goal;
@synthesize default_step;
@synthesize color;
@synthesize count_updown;
@synthesize display_total;
@synthesize screen;
@synthesize position;
@synthesize deleted;
@synthesize created_on;

- (id)initWithKey:(NSInteger)k {
	if (self = [super init]) {
		FMDatabase *dbh = UIAppDelegate.database;
		key = k;
		if (key) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT * FROM items WHERE id = ?", [NSNumber numberWithInt:key], nil];
			if ([rs next]) {
				self.name = [rs stringForColumn:@"name"];
				self.default_note = [rs stringForColumn:@"default_note"];
				self.default_tags = [rs stringForColumn:@"default_tags"];
				self.initial_value = [rs doubleForColumn:@"initial_value"];
				self.goal = [rs doubleForColumn:@"goal"];
				self.default_step = [rs doubleForColumn:@"default_step"];
				self.color = [rs stringForColumn:@"color"];
				self.count_updown = [rs intForColumn:@"count_updown"];
				self.display_total = [rs intForColumn:@"display_total"];
				self.screen = [rs intForColumn:@"screen"];
				self.position = [rs intForColumn:@"position"];
				self.deleted = [rs intForColumn:@"deleted"];
				self.created_on = [rs stringForColumn:@"created_on"];
			}
			[rs close];
		} else {
			self.initial_value = 0;
			self.goal = 0;
			self.default_step = 1;
			self.count_updown = 1;
			self.display_total = 1;
		}
		
		counts = nil;
	}
	return self;
}

- (BOOL)save {
	FMDatabase *dbh = UIAppDelegate.database;
	if (key == 0) {
		// INSERT
		[dbh executeUpdate:@"INSERT into items (name, default_note, default_tags, initial_value, \
												goal, default_step, color, count_updown, display_total, \
											    screen, position, deleted, created_on, created_tz, \
												modified_on, modified_tz) VALUES \
												(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, \
												datetime('now', 'localtime'), ?, datetime('now', 'localtime'), ?)",
			name,
			default_note,
			default_tags,
			[NSNumber numberWithDouble:initial_value],
			[NSNumber numberWithDouble:goal],
			[NSNumber numberWithDouble:default_step],
			color,
			[NSNumber numberWithInt:count_updown],
			[NSNumber numberWithInt:display_total],
			[NSNumber numberWithInt:screen],
			[NSNumber numberWithInt:position],
			[NSNumber numberWithInt:deleted],
			@"",
			@"",
			nil];
		if ([dbh hadError]) {
			return NO;
		} else {
			return YES;
		}
	} else {
		// UPDATE
		[dbh executeUpdate:@"UPDATE items \
								SET name = ?, \
									default_note = ?, \
									default_tags = ?, \
									initial_value = ?, \
									goal = ?, \
									default_step = ?, \
									color = ?, \
									count_updown = ?, \
									display_total = ?, \
									screen = ?, \
									position = ?, \
									deleted = ?, \
									modified_on = datetime('now', 'localtime'),\
									modified_tz = ? \
							 WHERE id = ?",
		 name,
		 default_note,
		 default_tags,
		 [NSNumber numberWithDouble:initial_value],
		 [NSNumber numberWithDouble:goal],
		 [NSNumber numberWithDouble:default_step],
		 color,
		 [NSNumber numberWithInt:count_updown],
		 [NSNumber numberWithInt:display_total],
		 [NSNumber numberWithInt:screen],
		 [NSNumber numberWithInt:position],
		 [NSNumber numberWithInt:deleted],
		 @"",
		 key,
		 nil];
		
		if ([dbh hadError]) {
			return NO;
		} else {
			return YES;
		}		
	}
}

- (void)loadCounts {
}

- (void)dealloc {
	[super dealloc];
	
	[name release];
	[default_note release];
	[default_tags release];
	[color release];
	[created_on release];
}
@end
