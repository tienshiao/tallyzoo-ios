//
//  TZItem.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TZActivity.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"
#import "UIColor-Expanded.h"
#import "TZCount.h"

@implementation TZActivity

@synthesize key;
@synthesize name;
@synthesize default_note;
@synthesize default_tags;
@synthesize initial_value;
@synthesize init_sig;
@synthesize default_step;
@synthesize step_sig;
@synthesize color;
@synthesize public;
@synthesize count_updown;
@synthesize display_total;
@synthesize screen;
@synthesize position;
@synthesize deleted;
@synthesize created_on;
@synthesize counts;

- (id)initWithKey:(NSInteger)k {
	if (self = [super init]) {
		FMDatabase *dbh = UIAppDelegate.database;
		key = k;
		if (key) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT * FROM activities WHERE id = ?", [NSNumber numberWithInt:key]];
			if ([rs next]) {
				self.name = [rs stringForColumn:@"name"];
				self.default_note = [rs stringForColumn:@"default_note"];
				self.default_tags = [rs stringForColumn:@"default_tags"];
				self.initial_value = [rs doubleForColumn:@"initial_value"];
				self.init_sig = [rs intForColumn:@"init_sig"];
				self.default_step = [rs doubleForColumn:@"default_step"];
				self.step_sig = [rs intForColumn:@"step_sig"];
				self.color = [UIColor colorWithHexString:[rs stringForColumn:@"color"]];
				self.count_updown = [rs intForColumn:@"count_updown"];
				self.display_total = [rs boolForColumn:@"display_total"];
				self.screen = [rs intForColumn:@"screen"];
				self.position = [rs intForColumn:@"position"];
				self.deleted = [rs boolForColumn:@"deleted"];
				self.created_on = [rs stringForColumn:@"created_on"];
			}
			[rs close];
			
			if ([dbh intForQuery:@"SELECT count(*) FROM groups_activities WHERE group_id = 0 and activity_id = ?", [NSNumber numberWithInt:key]]) {
				self.public = YES;
			} else {
				self.public = NO;
			}
		} else {
			self.public = YES;
			self.initial_value = 0;
			self.init_sig = 0;
			self.default_step = 1;
			self.step_sig = 0;
			self.count_updown = 1;
			self.display_total = 1;
			self.color = [UIColor whiteColor];
			self.screen = -1;
			self.position = 0;
		}
		
		counts = nil;
		formatter = [[NSNumberFormatter alloc] init];
		[formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
	}
	return self;
}

- (BOOL)needsPosition {
	FMDatabase *dbh = UIAppDelegate.database;
	if (screen < 0) {
		return YES;
	}
	if (position < 0 || position > 8) {
		return YES;
	}
	
	FMResultSet *rs = [dbh executeQuery:@"SELECT count(*) AS c FROM activities WHERE id <> ? AND screen = ? AND position = ? AND deleted = 0",
							[NSNumber numberWithInt:key], [NSNumber numberWithInt:screen], [NSNumber numberWithInt:position]];
	[rs next];
	if ([rs intForColumn:@"c"] == 0) {
		return NO;
	} else {
		return YES;
	}
}

- (void)findNextPosition {
	int _s = 0;
	int _p = 0;
	FMDatabase *dbh = UIAppDelegate.database;
	
	while (YES) {
		for (_p = 0; _p < 9; _p++) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT count(*) AS c FROM activities WHERE screen = ? AND position = ? AND deleted = 0",
							   [NSNumber numberWithInt:_s], [NSNumber numberWithInt:_p]];
			[rs next];
			if ([dbh hadError]) {
				NSLog(@"Err %d: %@", [dbh lastErrorCode], [dbh lastErrorMessage]);
				return;
			}
			if ([rs intForColumn:@"c"] == 0) {
				screen = _s;
				position = _p;
				return;
			}
		}
		_s++;
	}
}

- (BOOL)save {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if ([self needsPosition]) {
		[self findNextPosition];
	}
	
	if (key == 0) {
		// INSERT
		CFUUIDRef uuid = CFUUIDCreate(NULL);
		CFStringRef guid = CFUUIDCreateString(NULL, uuid);
		CFRelease(uuid);
		
		[dbh executeUpdate:@"INSERT into activities (guid, name, default_note, default_tags, initial_value, init_sig,\
												default_step, step_sig, color, count_updown, display_total, \
											    screen, position, deleted, created_on, created_tz, \
												modified_on, modified_tz) VALUES \
												(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, \
												datetime('now', 'localtime'), ?, datetime('now', 'localtime'), ?)",
			(NSString *)guid,
		    name,
			default_note,
			default_tags,
			[NSNumber numberWithDouble:initial_value],
			[NSNumber numberWithInt:init_sig],
			[NSNumber numberWithDouble:default_step],
			[NSNumber numberWithInt:step_sig],
			[color hexStringFromColor],
			[NSNumber numberWithInt:count_updown],
			[NSNumber numberWithBool:display_total],
			[NSNumber numberWithInt:screen],
			[NSNumber numberWithInt:position],
			[NSNumber numberWithInt:[[NSTimeZone systemTimeZone] secondsFromGMT]],
			[NSNumber numberWithInt:[[NSTimeZone systemTimeZone] secondsFromGMT]]
		   ];
		CFRelease(guid);
		if ([dbh hadError]) {
			return NO;
		} 

		key = [dbh lastInsertRowId];
		
		if (public) {
			[dbh executeUpdate:@"INSERT INTO groups_activities (group_id, activity_id) VALUES (0, ?)", [NSNumber numberWithInt:key]];
			
			if ([dbh hadError]) {
				return NO;
			}
		}
		
		return YES;
	} else {
		// UPDATE
		[dbh executeUpdate:@"UPDATE activities \
								SET name = ?, \
									default_note = ?, \
									default_tags = ?, \
									initial_value = ?, \
									init_sig = ?, \
									default_step = ?, \
									step_sig = ?, \
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
		 [NSNumber numberWithInt:init_sig],
		 [NSNumber numberWithDouble:default_step],
		 [NSNumber numberWithInt:step_sig],
		 [color hexStringFromColor],
		 [NSNumber numberWithInt:count_updown],
		 [NSNumber numberWithBool:display_total],
		 [NSNumber numberWithInt:screen],
		 [NSNumber numberWithInt:position],
		 [NSNumber numberWithBool:deleted],
		 [NSNumber numberWithInt:[[NSTimeZone systemTimeZone] secondsFromGMT]],
		 [NSNumber numberWithInt:key]
		];
		
		if ([dbh hadError]) {
			return NO;
		}
		
		if (public) {
			[dbh executeUpdate:@"INSERT INTO groups_activities (group_id, activity_id) VALUES (0, ?)", [NSNumber numberWithInt:key]];
		} else {
			[dbh executeUpdate:@"DELETE FROM groups_activities WHERE group_id = 0 AND activity_id = ?", [NSNumber numberWithInt:key]];
		}

		if ([dbh hadError]) {
			return NO;
		}
		
		return YES;
	}
}

- (void)loadCounts {
	[counts removeAllObjects];
	
	counts = [[NSMutableArray alloc] init];

	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM counts WHERE activity_id = ? AND deleted = 0 ORDER BY created_on",
					   [NSNumber numberWithInt:key]];
	while ([rs next]) {
		TZCount *c = [[TZCount alloc] initWithKey:[rs intForColumn:@"id"] andActivity:self];
		[counts addObject:c];
		[c release];
	}
	
}

- (void)simpleCount {
	TZCount *count = [[TZCount alloc] initWithKey:0 andActivity:self];
	count.amount = count_updown * default_step;
	[count save];
	[count release];
}

-(NSString *)sum {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT SUM(amount) AS total, MAX(amount_sig) AS amount_sig FROM counts WHERE activity_id = ? AND deleted = 0",
	   [NSNumber numberWithInt:key]];
	[rs next];
	
	double total = [rs doubleForColumn:@"total"];
	int sig = [rs intForColumn:@"amount_sig"];
	
	if (sig < init_sig) {
		sig = init_sig;
	}
	if (sig < step_sig) {
		sig = step_sig;
	}

	[formatter setMaximumFractionDigits:sig];
	[formatter setMinimumFractionDigits:sig];
	
	NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:initial_value + total]];

	return numberString;
}

- (void)dealloc {
	[super dealloc];
	
	[name release];
	[default_note release];
	[default_tags release];
	[color release];
	[created_on release];
	
	[counts release];
	[formatter release];
}
@end
