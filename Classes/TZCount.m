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
@synthesize guid;
@synthesize key;
@synthesize note;
@synthesize tags;
@synthesize amount;
@synthesize amount_sig;
@synthesize latitude;
@synthesize longitude;
@synthesize deleted;
@synthesize created_on;
@synthesize created_on_UTC;
@synthesize modified_on;
@synthesize modified_on_UTC;
@synthesize activity_id;

- (id)initWithKey:(int)k andActivity:(TZActivity *)a {
	if (self = [super init]) {
		FMDatabase *dbh = UIAppDelegate.database;
		key = k;
		if (key) {
			FMResultSet *rs = [dbh executeQuery:@"SELECT * FROM counts WHERE id = ? AND deleted = 0", [NSNumber numberWithInt:key]];
			if ([rs next]) {
				self.guid = [rs stringForColumn:@"guid"];
				self.note = [rs stringForColumn:@"note"];
				self.tags = [rs stringForColumn:@"tags"];
				self.amount = [rs doubleForColumn:@"amount"];
				self.amount_sig = [rs intForColumn:@"amount_sig"];
				self.latitude = [rs doubleForColumn:@"latitude"];
				self.longitude = [rs doubleForColumn:@"longitude"];
				self.deleted = [rs boolForColumn:@"deleted"];
				self.created_on = [rs stringForColumn:@"created_on"];
				self.created_on_UTC = [rs stringForColumn:@"created_on_UTC"];
				self.modified_on = [rs stringForColumn:@"modified_on"];
				self.modified_on_UTC = [rs stringForColumn:@"modified_on_UTC"];
				self.activity_id = [rs intForColumn:@"activity_id"];
			}
			[rs close];
		} else {
			self.note = @"";
			self.tags = a.default_tags;
			self.amount = a.default_step;
			self.amount_sig = a.step_sig;
			

			CLLocation *location = UIAppDelegate.location;
			
			self.longitude = location.coordinate.longitude;
			self.latitude = location.coordinate.latitude;
			
			self.deleted = NO;

			NSDate *now = [NSDate date];
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
			self.created_on = [dateFormatter stringFromDate:now];
		
			NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
			[dateFormatter setTimeZone:timeZone];
			
			self.created_on_UTC = [dateFormatter stringFromDate:now];
			
			[dateFormatter release];
		}

		activity = a;
	}
	return self;
}

- (id)initWithGUID:(NSString *)g andActivity:(TZActivity *)a {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if (g) {
		FMResultSet *rs = [dbh executeQuery:@"SELECT id FROM counts WHERE guid = ?", g];
		if ([rs next]) {
			return [self initWithKey:[rs intForColumn:@"id"] andActivity:a];
		}
	}
	return [self initWithKey:0 andActivity:a];
}

- (void)dealloc {
	[note release];
	note = nil;
	[tags release];
	tags = nil;
	
	[guid release];
	guid = nil;
	
	[created_on release];
	created_on = nil;
	[created_on_UTC release];
	created_on_UTC = nil;
	[modified_on release];
	modified_on = nil;
	[modified_on_UTC release];
	modified_on_UTC = nil;

	[super dealloc];
}

- (BOOL)save {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if (key == 0) {
		// TODO if no location data
		// INSERT
		CFUUIDRef uuid = CFUUIDCreate(NULL);
		CFStringRef guid = CFUUIDCreateString(NULL, uuid);
		CFRelease(uuid);
		
		[dbh executeUpdate:@"INSERT INTO counts (guid, activity_id, note, tags, amount, amount_sig,\
		 latitude, longitude, deleted, created_on, created_on_UTC, \
		 modified_on, modified_on_UTC) VALUES \
		 (?, ?, ?, ?, ?, ?, ?, ?, 0, \
		 ?, ?, datetime('now', 'localtime'), datetime('now'))",
		 (NSString *)guid,
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithInt:amount_sig],
		 [NSNumber numberWithDouble:latitude],
 		 [NSNumber numberWithDouble:longitude],
		 created_on,
		 created_on_UTC
		];
		
		CFRelease(guid);
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
				created_on = ?,\
				created_on_UTC = ?,\
				modified_on = datetime('now', 'localtime'),\
				modified_on_UTC = datetime('now')\
				WHERE id = ?",
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithInt:amount_sig],
		 [NSNumber numberWithDouble:latitude],
		 [NSNumber numberWithDouble:longitude],
		 [NSNumber numberWithBool:deleted],
		 created_on,
		 created_on_UTC,
		 [NSNumber numberWithInt:key]
		];
		
		if ([dbh hadError]) {
			return NO;
		} else {
			return YES;
		}		
	}	
}

- (BOOL)saveRaw {
	FMDatabase *dbh = UIAppDelegate.database;
	
	if (key == 0) {
		// INSERT
		[dbh executeUpdate:@"INSERT INTO counts (guid, activity_id, note, tags, amount, amount_sig,\
		 latitude, longitude, deleted, created_on, created_on_UTC, \
		 modified_on, modified_on_UTC) VALUES \
		 (?, ?, ?, ?, ?, ?, ?, ?, 0, \
		 ?, ?, ?, ?)",
		 guid,
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithInt:amount_sig],
		 [NSNumber numberWithDouble:latitude],
 		 [NSNumber numberWithDouble:longitude],
		 created_on,
		 created_on_UTC,
		 modified_on,
		 modified_on_UTC
		 ];
		
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
		 created_on = ?,\
		 created_on_UTC = ?,\
		 modified_on = ?,\
		 modified_on_UTC = ?\
		 WHERE guid = ?",
		 [NSNumber numberWithInt:activity.key],
		 note,
		 tags,
		 [NSNumber numberWithDouble:amount],
		 [NSNumber numberWithInt:amount_sig],
		 [NSNumber numberWithDouble:latitude],
		 [NSNumber numberWithDouble:longitude],
		 [NSNumber numberWithBool:deleted],
		 created_on,
		 created_on_UTC,
		 modified_on,
		 modified_on_UTC,
		 guid
		 ];
		
		if ([dbh hadError]) {
			return NO;
		} else {
			return YES;
		}		
	}	
}


@end
