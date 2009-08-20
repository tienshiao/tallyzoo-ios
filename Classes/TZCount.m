//
//  TZCount.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/29/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "TZCount.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"


@implementation TZCount

@synthesize activity;
@synthesize key;
@synthesize note;
@synthesize tags;
@synthesize amount;
@synthesize amount_sig;
@synthesize latitude;
@synthesize longitude;
@synthesize deleted;

- (id)initWithKey:(int)k andActivity:(TZActivity *)a {
	if (self = [super init]) {
		FMDatabase *dbh = UIAppDelegate.database;
		key = k;
		if (key) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT * FROM counts WHERE id = ? AND deleted = 0", [NSNumber numberWithInt:key], nil];
			if ([rs next]) {
				self.note = [rs stringForColumn:@"note"];
				self.tags = [rs stringForColumn:@"tags"];
				self.amount = [rs doubleForColumn:@"amount"];
				self.amount_sig = [rs intForColumn:@"amount_sig"];
				self.latitude = [rs doubleForColumn:@"latitude"];
				self.longitude = [rs doubleForColumn:@"longitude"];
				self.deleted = [rs boolForColumn:@"deleted"];
			}
			[rs close];
		} else {
			self.note = @"";
			self.tags = a.default_tags;
			self.amount = a.default_step;
			self.amount_sig = a.step_sig;
			
			// TODO ask for permission to use location earlier
			self.latitude = 0.0;
			self.longitude = 0.0;
			
			self.deleted = NO;
		}

		activity = a;
	}
	return self;
}

- (void)dealloc {
	[super dealloc];

	[note release];
	[tags release];
}

- (BOOL)save {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if (key == 0) {
		// INSERT
		[dbh executeUpdate:@"INSERT INTO counts (activity_id, note, tags, amount, amount_sig,\
		 latitude, longitude, deleted, created_on, created_tz, \
		 modified_on, modified_tz) VALUES \
		 (?, ?, ?, ?, ?, ?, ?, 0, \
		 datetime('now', 'localtime'), ?, datetime('now', 'localtime'), ?)",
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithInt:amount_sig],
		 [NSNumber numberWithDouble:latitude],
 		 [NSNumber numberWithDouble:longitude],
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
		[dbh executeUpdate:@"UPDATE counts \
			SET activity_id = ?, \
				note = ?, \
				tags = ?, \
				amount = ?, \
				amount_sig = ?, \
				latitude = ?, \
				longitude = ?, \
				deleted = ?, \
				modified_on = datetime('now', 'localtime'),\
				modified_tz = ? \
				WHERE id = ?",
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithInt:amount_sig],
		 [NSNumber numberWithDouble:latitude],
		 [NSNumber numberWithDouble:longitude],
		 [NSNumber numberWithBool:deleted],
		 @"",
		 [NSNumber numberWithInt:key],
		 nil];
		
		if ([dbh hadError]) {
			return NO;
		} else {
			return YES;
		}		
	}	
}

@end
