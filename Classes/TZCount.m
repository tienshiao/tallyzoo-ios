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
@synthesize latitude;
@synthesize longitude;

- (id)initWithKey:(int)k andActivity:(TZActivity *)a {
	if (self = [super init]) {
		FMDatabase *dbh = UIAppDelegate.database;
		key = k;
		if (key) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT * FROM counts WHERE id = ?", [NSNumber numberWithInt:key], nil];
			if ([rs next]) {
				self.note = [rs stringForColumn:@"note"];
				self.tags = [rs stringForColumn:@"tags"];
				self.amount = [rs doubleForColumn:@"amount"];
				self.latitude = [rs doubleForColumn:@"latitude"];
				self.longitude = [rs doubleForColumn:@"longitude"];
			}
			[rs close];
		} else {
			self.note = @"";
			self.tags = a.default_tags;
			self.amount = a.default_step;
			
			// TODO ask for permission to use location earlier
			self.latitude = 0.0;
			self.longitude = 0.0;
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
		[dbh executeUpdate:@"INSERT INTO counts (activity_id, note, tags, amount, \
		 latitude, longitude, created_on, created_tz, \
		 modified_on, modified_tz) VALUES \
		 (?, ?, ?, ?, ?, ?, \
		 datetime('now', 'localtime'), ?, datetime('now', 'localtime'), ?)",
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
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
				latitude = ?, \
				longitude = ?, \
				modified_on = datetime('now', 'localtime'),\
				modified_tz = ? \
				WHERE id = ?",
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithDouble:latitude],
		 [NSNumber numberWithDouble:longitude],
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

@end
