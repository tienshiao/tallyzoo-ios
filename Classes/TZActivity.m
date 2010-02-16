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
#import "FMDatabaseAdditions.h"
#import "UIColor-Expanded.h"
#import "TZCount.h"

@implementation TZActivity

@synthesize guid;
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
@synthesize graph_type;
@synthesize deleted;
@synthesize created_on;
@synthesize created_on_UTC;
@synthesize modified_on;
@synthesize modified_on_UTC;
@synthesize counts;

+ (BOOL)nameExists:(NSString *)n {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh intForQuery:@"SELECT count(*) FROM activities WHERE deleted = 0 AND upper(name) = upper(?)", n];
}

+ (BOOL)otherExists:(NSString *)n not:(NSInteger)key {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh intForQuery:@"SELECT count(*) FROM activities WHERE deleted = 0 AND upper(name) = upper(?) AND id <> ?", n, [NSNumber numberWithInt:key]];
}

+ (NSInteger)activeCount {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh intForQuery:@"SELECT count(*) FROM activities WHERE deleted = 0"];

}

- (id)initWithKey:(NSInteger)k {
	if (self = [super init]) {
		FMDatabase *dbh = UIAppDelegate.database;
		key = k;
		if (key) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT * FROM activities WHERE id = ?", [NSNumber numberWithInt:key]];
			if ([rs next]) {
				self.guid = [rs stringForColumn:@"guid"];
				self.name = [rs stringForColumn:@"name"];
				self.default_note = [rs stringForColumn:@"default_note"];
				self.default_tags = [rs stringForColumn:@"default_tags"];
				self.initial_value = [rs doubleForColumn:@"initial_value"];
				self.init_sig = [rs intForColumn:@"init_sig"];
				self.default_step = [rs doubleForColumn:@"default_step"];
				self.step_sig = [rs intForColumn:@"step_sig"];
				self.color = [UIColor colorWithHexString:[rs stringForColumn:@"color"]];
				self.count_updown = [rs intForColumn:@"count_updown"];
				self.display_total = [rs intForColumn:@"display_total"];
				self.screen = [rs intForColumn:@"screen"];
				self.position = [rs intForColumn:@"position"];
				self.graph_type = [rs intForColumn:@"graph_type"];
				self.deleted = [rs boolForColumn:@"deleted"];
				self.created_on = [rs stringForColumn:@"created_on"];
				self.created_on_UTC = [rs stringForColumn:@"created_on_UTC"];
				self.modified_on = [rs stringForColumn:@"modified_on"];
				self.modified_on_UTC = [rs stringForColumn:@"modified_on_UTC"];
			}
			[rs close];
			
			if ([dbh intForQuery:@"SELECT count(*) FROM groups_activities WHERE group_id = 0 and activity_id = ?", [NSNumber numberWithInt:key]]) {
				self.public = YES;
			} else {
				self.public = NO;
			}
		} else {
			self.default_note = @"";
			self.default_tags = @"";
			self.public = YES;
			self.initial_value = 0;
			self.init_sig = 0;
			self.default_step = 1;
			self.step_sig = 0;
			self.count_updown = 1;
			self.display_total = 1;
			self.color = [UIColor blueColor];
			self.screen = -1;
			self.position = 0;
			self.graph_type = 1;
		}
		
		counts = [[NSMutableArray alloc] init];

		formatter = [[NSNumberFormatter alloc] init];
		[formatter setRoundingMode: NSNumberFormatterRoundHalfEven];
	}
	return self;
}

- (id)initWithGUID:(NSString *)g {
	FMDatabase *dbh = UIAppDelegate.database;

	if (g) {
		FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM activities WHERE guid = ?", g];
		if ([rs next]) {
			return [self initWithKey:[rs intForColumn:@"id"]];
		}
	}
	return [self initWithKey:0];
}

- (id)initWithName:(NSString *)n {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if (n) {
		FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM activities WHERE name = ?", n];
		if ([rs next]) {
			return [self initWithKey:[rs intForColumn:@"id"]];
		}
	}
	return [self initWithKey:0];
}

- (BOOL)needsPosition {
//	FMDatabase *dbh = UIAppDelegate.database;
	if (screen < 0) {
		return YES;
	}
	if (position < 0 || position > 8) {
		return YES;
	}
	
/*	FMResultSet *rs = [dbh executeQuery:@"SELECT count(*) AS c FROM activities WHERE id <> ? AND screen = ? AND position = ? AND deleted = 0",
							[NSNumber numberWithInt:key], [NSNumber numberWithInt:screen], [NSNumber numberWithInt:position]];
	[rs next];
	if ([rs intForColumn:@"c"] == 0) {
		[rs close];
		return NO;
	} else {
		[rs close];
		return YES;
	}*/
	
	return NO;
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
				[rs close];
				return;
			}
			[rs close];
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
		CFStringRef guidstr = CFUUIDCreateString(NULL, uuid);
		CFRelease(uuid);
		
		[dbh executeUpdate:@"INSERT into activities (guid, name, default_note, default_tags, initial_value, init_sig,\
												default_step, step_sig, color, count_updown, display_total, \
											    screen, position, graph_type, deleted, created_on, created_on_UTC, \
												modified_on, modified_on_UTC) VALUES \
												(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 0, \
												datetime('now', 'localtime'), datetime('now'), datetime('now', 'localtime'), datetime('now'))",
			(NSString *)guidstr,
		    name,
			default_note,
			default_tags,
			[NSNumber numberWithDouble:initial_value],
			[NSNumber numberWithInt:init_sig],
			[NSNumber numberWithDouble:default_step],
			[NSNumber numberWithInt:step_sig],
			[color hexStringFromColor],
			[NSNumber numberWithInt:count_updown],
		    [NSNumber numberWithInt:display_total],
			[NSNumber numberWithInt:screen],
			[NSNumber numberWithInt:position],
			[NSNumber numberWithInt:graph_type]
		   ];
		CFRelease(guidstr);
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
									graph_type = ?, \
									deleted = ?, \
									modified_on = datetime('now', 'localtime'),\
									modified_on_UTC = datetime('now')\
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
		 [NSNumber numberWithInt:display_total],
		 [NSNumber numberWithInt:screen],
		 [NSNumber numberWithInt:position],
		 [NSNumber numberWithInt:graph_type],
		 [NSNumber numberWithBool:deleted],
		 [NSNumber numberWithInt:key]
		];
		
		if ([dbh hadError]) {
			return NO;
		}
		
		if (public) {
			[dbh executeUpdate:@"INSERT OR IGNORE INTO groups_activities (group_id, activity_id) VALUES (0, ?)", [NSNumber numberWithInt:key]];
		} else {
			[dbh executeUpdate:@"DELETE FROM groups_activities WHERE group_id = 0 AND activity_id = ?", [NSNumber numberWithInt:key]];
		}

		if ([dbh hadError]) {
			return NO;
		}
		
		return YES;
	}
}


- (BOOL)saveRaw {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if ([self needsPosition]) {
		[self findNextPosition];
	}
	
	if (key == 0) {
		// INSERT
		[dbh executeUpdate:@"INSERT into activities (guid, name, default_note, default_tags, initial_value, init_sig,\
		 default_step, step_sig, color, count_updown, display_total, \
		 screen, position, graph_type, deleted, created_on, created_on_UTC, \
		 modified_on, modified_on_UTC) VALUES \
		 (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, \
		 ?, ?, ?, ?)",
		 guid,
		 name,
		 default_note,
		 default_tags,
		 [NSNumber numberWithDouble:initial_value],
		 [NSNumber numberWithInt:init_sig],
		 [NSNumber numberWithDouble:default_step],
		 [NSNumber numberWithInt:step_sig],
		 [color hexStringFromColor],
		 [NSNumber numberWithInt:count_updown],
		 [NSNumber numberWithInt:display_total],
		 [NSNumber numberWithInt:screen],
		 [NSNumber numberWithInt:position],
		 [NSNumber numberWithInt:graph_type],
		 [NSNumber numberWithInt:deleted],
		 created_on,
		 created_on_UTC,
		 modified_on,
		 modified_on_UTC
		 ];

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
		 graph_type = ?, \
		 deleted = ?, \
		 created_on = ?,\
		 created_on_UTC = ?,\
		 modified_on = ?,\
		 modified_on_UTC = ?\
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
		 [NSNumber numberWithInt:display_total],
		 [NSNumber numberWithInt:screen],
		 [NSNumber numberWithInt:position],
		 [NSNumber numberWithInt:graph_type],
		 [NSNumber numberWithBool:deleted],
		 created_on,
		 created_on_UTC,
		 modified_on,
		 modified_on_UTC,
		 [NSNumber numberWithInt:key]
		 ];
		
		if ([dbh hadError]) {
			return NO;
		}
		
		if (public) {
			[dbh executeUpdate:@"INSERT OR IGNORE INTO groups_activities (group_id, activity_id) VALUES (0, ?)", [NSNumber numberWithInt:key]];
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
	if ([counts count]) {
		return;
	}
	
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM counts WHERE activity_id = ? AND deleted = 0 ORDER BY created_on",
					   [NSNumber numberWithInt:key]];
	while ([rs next]) {
		TZCount *c = [[TZCount alloc] initWithKey:[rs intForColumn:@"id"] andActivity:self];
		[counts addObject:c];
		[c release];
	}
	[rs close];
}

- (NSMutableArray *)getDayCounts {
	NSMutableArray *counts = [[[NSMutableArray alloc] init] autorelease];
	
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = [dbh executeQuery:@"SELECT SUM(amount) AS amount, MAX(amount_sig) AS amount_sig, DATETIME(DATE(created_on)) AS created_on FROM counts WHERE activity_id = ? AND deleted = 0 GROUP BY DATE(created_on);",
					   [NSNumber numberWithInt:key]];
					   
	while ([rs next]) {
		TZCount *c = [[TZCount alloc] initWithKey:0 andActivity:self];
		c.amount = [rs doubleForColumn:@"amount"];
		c.amount_sig = [rs intForColumn:@"amount_sig"];
		c.created_on = [rs stringForColumn:@"created_on"];
		[counts addObject:c];
		[c release];
	}
	[rs close];
	
	return counts;
}

- (void)simpleCount {
	TZCount *count = [[TZCount alloc] initWithKey:0 andActivity:self];
	count.amount = count_updown * default_step;
	[count save];
	[count release];
}

-(NSString *)sum {
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs = nil;
	
	double init_val = 0.0;

	if (display_total == 1) {
		// all
		rs = [dbh executeQuery:@"SELECT SUM(amount) AS total, MAX(amount_sig) AS amount_sig FROM counts WHERE activity_id = ? AND deleted = 0",
				[NSNumber numberWithInt:key]];
		init_val = initial_value;
	} else if (display_total == 2) {
		// daily
		rs = [dbh executeQuery:@"SELECT SUM(amount) AS total, MAX(amount_sig) AS amount_sig FROM counts WHERE activity_id = ? AND deleted = 0 AND created_on >= date('now', 'localtime')",
			  [NSNumber numberWithInt:key]];
		init_val = [dbh doubleForQuery:@"SELECT SUM(initial_value) FROM activities WHERE key = ? AND created_on >= date('now', 'localtime')", key];
	} else if (display_total == 3) {
		// weekly
		NSCalendar *calendar = [NSCalendar currentCalendar];
		NSDate *today = [[NSDate alloc] init];
		NSDate *beginningOfWeek = nil;
		BOOL ok = [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&beginningOfWeek
								interval:NULL forDate:today];
		NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
		[dateFormatter setDateFormat:@"yyyy-MM-dd 00:00:00"];
		rs = [dbh executeQuery:@"SELECT SUM(amount) AS total, MAX(amount_sig) AS amount_sig FROM counts WHERE activity_id = ? AND deleted = 0 AND created_on >= ?",
			  [NSNumber numberWithInt:key], [dateFormatter stringFromDate:beginningOfWeek]];
		init_val = [dbh doubleForQuery:@"SELECT SUM(initial_value) FROM activities WHERE key = ? AND created_on >= ?", key, [dateFormatter stringFromDate:beginningOfWeek]];
		[today release];
	} else if (display_total == 4) {
		// monthly
		rs = [dbh executeQuery:@"SELECT SUM(amount) AS total, MAX(amount_sig) AS amount_sig FROM counts WHERE activity_id = ? AND deleted = 0 AND created_on >= date('now', 'localtime', 'start of month')",
			  [NSNumber numberWithInt:key]];
		init_val = [dbh doubleForQuery:@"SELECT SUM(initial_value) FROM activities WHERE key = ? AND created_on >= date('now', 'localtime', 'start of month')", key];
	}
	[rs next];
	
	if ([dbh hadError]) {
        NSLog(@"Err %d: %@", [dbh lastErrorCode], [dbh lastErrorMessage]);
    }
    
	
	double total = [rs doubleForColumn:@"total"];
	int sig = [rs intForColumn:@"amount_sig"];
	
	if (sig < init_sig) {
		sig = init_sig;
	}

	[formatter setMaximumFractionDigits:sig];
	[formatter setMinimumFractionDigits:sig];
	
	NSString *numberString = [formatter stringFromNumber:[NSNumber numberWithDouble:init_val + total]];

	return numberString;
}

- (void)dealloc {
	[guid release];
	guid = nil;
	[name release];
	name = nil;
	[default_note release];
	default_note = nil;
	[default_tags release];
	default_tags = nil;
	[color release];
	color = nil;
	[created_on release];
	created_on = nil;
	[created_on_UTC release];
	created_on_UTC = nil;
	[modified_on release];
	modified_on = nil;
	[modified_on_UTC release];
	modified_on_UTC = nil;
	
	[counts release];
	counts = nil;
	[formatter release];
	formatter = nil;

	[super dealloc];
}
@end
