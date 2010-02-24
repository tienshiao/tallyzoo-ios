//
//  Syncer.m
//  TallyZoo Free
//
//  Created by Tienshiao Ma on 2/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import "Syncer.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "UIColor-Expanded.h"
#import "SFHFKeychainUtils.h"
#import "TZCount.h"
#import "GTMNSString+XML.h"

@implementation Syncer

@synthesize apiURL;
@synthesize lastSync;
@synthesize state;
@synthesize delegate;
@synthesize message;
@synthesize username;
@synthesize password;
@synthesize synced;

- (id)init {
	if (self = [super init]) {		
		state = 0;
		synced = NO;
		
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		self.lastSync = [defaults stringForKey:@"lastSync"];
		
		self.apiURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"];
		if ([apiURL length] == 0) {
			self.apiURL = @"www.tallyzoo.com/api.php";
		}
	}
	return self;
}


- (NSString *)getCurrentDBTime {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh stringForQuery:@"SELECT datetime('now')"];
}

- (BOOL)getServerUpdates {
	NSString *urlString = [NSString stringWithFormat:@"http://%@:%@@%@/activities.list", 
						   [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
						   [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding], 
						   apiURL];
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
													   timeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	NSString *body;
	if (lastSync) {
		body = [NSString stringWithFormat:@"<request currenttime=\"%@\"><since datetime=\"%@\" /></request>", [self getCurrentDBTime], lastSync];
	} else {
		body = [NSString stringWithFormat:@"<request currenttime=\"%@\"></request>", [self getCurrentDBTime]];
	}
	
	//NSLog(body);
	
	[request setHTTPBody:[NSData dataWithBytes:[body UTF8String] length:strlen([body UTF8String])]];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		self.message = @"Downloading Updates ...";
		self.progress = 0.02;
		return YES;
	} else {
		return NO;
	}	
}

- (void)parseActivities {
	// parse XML and merge with data
	[xmlParser release];
	xmlParser = [[NSXMLParser alloc] initWithData:receivedData];
	[xmlParser setDelegate:self];
	
	[xmlParser setShouldProcessNamespaces:NO];
	[xmlParser setShouldReportNamespacePrefixes:NO];
	[xmlParser setShouldResolveExternalEntities:NO];
	
	[xmlParser parse];
}

- (NSString *)buildActivityXML:(TZActivity *)a {
	NSString *group;
	if (a.public) {
		group = @"<group name=\"Public\" id=\"0\" />";
	} else {
		group = @"";
	}
	return [NSString stringWithFormat:@"<request currenttime=\"%@\"><activity guid=\"%@\" name=\"%@\" default_note=\"%@\" initial_value=\"%f\" init_sig=\"%d\" default_step=\"%f\" step_sig=\"%d\" color=\"%@\" count_updown=\"%d\" display_total=\"%d\" screen=\"%d\" position=\"%d\" graph_type=\"%d\" deleted=\"%d\" created_on=\"%@\" created_on_UTC=\"%@\" modified_on=\"%@\" modified_on_UTC=\"%@\">%@</activity></request>",
			[self getCurrentDBTime],
			a.guid,
			[a.name gtm_stringBySanitizingAndEscapingForXML],
			[a.default_note gtm_stringBySanitizingAndEscapingForXML],
			a.initial_value,
			a.init_sig,
			a.default_step,
			a.step_sig,
			[a.color hexStringFromColor],
			a.count_updown,
			a.display_total,
			a.screen,
			a.position,
			a.graph_type,
			a.deleted,
			a.created_on,
			a.created_on_UTC,
			a.modified_on,
			a.modified_on_UTC,
			group
			];
}

- (NSString *)buildCountXML:(TZCount *)c {
	TZActivity *a = [[TZActivity alloc] initWithKey:c.activity_id];
	
	NSString *count = [NSString stringWithFormat:@"<request currenttime=\"%@\"><count guid=\"%@\" activity_guid=\"%@\" note=\"%@\" amount=\"%f\" amount_sig=\"%d\" latitude=\"%f\" longitude=\"%f\" deleted=\"%d\" created_on=\"%@\" created_on_UTC=\"%@\" modified_on=\"%@\" modified_on_UTC=\"%@\" /></request>",
					   [self getCurrentDBTime],
					   c.guid,
					   a.guid,
					   [c.note gtm_stringBySanitizingAndEscapingForXML],
					   c.amount,
					   c.amount_sig,
					   c.latitude,
					   c.longitude,
					   c.deleted,
					   c.created_on,
					   c.created_on_UTC,
					   c.modified_on,
					   c.modified_on_UTC
					   ];
	[a release];
	return count;
}

- (void)sendNextUpdate {
	if ([syncQueue count] == 0) {
		// All done
		
		// update last sync date/time
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		self.lastSync = [df stringFromDate:now];
		[df release];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:lastSync forKey:@"lastSync"];
		[defaults synchronize];
				
		[syncQueue release];
		syncQueue = nil;
		
		synced = YES;
		[delegate syncerCompleted:self];
		
		return;
	}
	
	NSObject *o = [syncQueue objectAtIndex:0];
	
	NSString *urlString;
	NSString *body;
	if ([o isKindOfClass:[TZActivity class]]) {
		urlString = [NSString stringWithFormat:@"http://%@:%@@%@/activities.update", 
					 [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					 [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					 apiURL];
		body = [self buildActivityXML:(TZActivity *)o];
	} else {
		urlString = [NSString stringWithFormat:@"http://%@:%@@%@/counts.update", 
					 [username stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					 [password stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],
					 apiURL];
		
		body = [self buildCountXML:(TZCount *)o];
	}
	
	//NSLog(body);
	
	NSURL *url = [NSURL URLWithString:urlString];
	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
														   cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData 
													   timeoutInterval:30];
	[request setHTTPMethod:@"POST"];
	[request setHTTPBody:[NSData dataWithBytes:[body UTF8String] length:strlen([body UTF8String])]];
	
	connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
	if (connection) {
		receivedData = [[NSMutableData alloc] init];
	} else {
		// TODO error
		[delegate syncerFailed:self];
	}		
}

- (void)initSyncQueue {
	[syncQueue release];
	syncQueue = [[NSMutableArray alloc] init];
	
	
	FMDatabase *dbh = UIAppDelegate.database;
	FMResultSet *rs;
	// get activities to sync
	if (lastSync) {
		rs = [dbh executeQuery:@"SELECT id FROM activities WHERE modified_on_UTC > ?", lastSync];
	} else {
		rs = [dbh executeQuery:@"SELECT id FROM activities"];
	}
	while ([rs next]) {
		TZActivity *a = [[TZActivity alloc] initWithKey:[rs intForColumn:@"id"]];
		[syncQueue addObject:a];
		[a release];
	}
	[rs close];
	
	// get counts to sync
	if (lastSync) {
		rs = [dbh executeQuery:@"SELECT id FROM counts WHERE modified_on_UTC > ?", lastSync];
	} else {
		rs = [dbh executeQuery:@"SELECT id FROM counts"];		
	}
	while ([rs next]) {
		TZCount *c = [[TZCount alloc] initWithKey:[rs intForColumn:@"id"] andActivity:nil];
		[syncQueue addObject:c];
		[c release];
	}
	[rs close];
	
	syncTotal = [syncQueue count];
}

- (void)updateServer {
	[self sendNextUpdate];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// make sure we get back a 200
	NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
	if ([r statusCode] != 200) {
		NSLog(@"connection failed with %d", [r statusCode]);
		state = 0;
		
		
		if ([r statusCode] == 401) {
			self.message = @"Unable to login. Please double check your username and password, and that your account has been activated via the email confirmation.";
		} else {
			self.message = @"An error occurred while syncing. Please try again later.";
		}
		
		[delegate syncerFailed:self];
	}
	receivedData = [[NSMutableData alloc] init];
	[receivedData setLength:0];
	self.progress = progress + 0.05;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	//NSString *body = [[NSString alloc] initWithBytes:[receivedData bytes] 
	//										  length:[receivedData length] 
	//										encoding:NSUTF8StringEncoding];
	//NSLog(body);
	
	if (state == STATE_RECEIVING) {
		self.progress = .15;
		// parse activities
		[self parseActivities];
		self.message = @"Updating Server ...";
		self.progress = .3;
		
		// now to update
		[connection release];
		[receivedData release];
		
		state = STATE_UPDATING;
		
		[self updateServer];
	} else if (state == STATE_UPDATING) {
		[connection release];
		[receivedData release];
		
		[syncQueue removeObjectAtIndex:0];
		[self sendNextUpdate];
		
		self.progress = .3 + ((float) (syncTotal - [syncQueue count])) / syncTotal * .7;
	}	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	self.message = [NSString stringWithFormat:@"Unable to connect to server (%@). Please try again later.", [error localizedDescription]];
	
	[delegate syncerFailed:self];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	//NSLog(@"found this element: %@", elementName);
	
	if ([elementName isEqualToString:@"activity"]) {
		currentActivity = [[TZActivity alloc] initWithGUID:[attributeDict valueForKey:@"guid"]];
		
		// if data is newer
		if (currentActivity.key == 0 ||
			[(NSString *)[attributeDict objectForKey:@"modified_on_UTC"] compare:currentActivity.modified_on_UTC] == NSOrderedDescending) {
			// load data
			currentActivity.guid = [attributeDict objectForKey:@"guid"];
			currentActivity.name = [attributeDict objectForKey:@"name"];
			
			currentActivity.color = [UIColor colorWithHexString:[attributeDict objectForKey:@"color"]];
			currentActivity.default_note = [attributeDict objectForKey:@"default_note"];
			currentActivity.default_tags = [attributeDict objectForKey:@"tags"];
			currentActivity.initial_value = [(NSString *)[attributeDict objectForKey:@"initial_value"] doubleValue];
			currentActivity.init_sig = [(NSString *)[attributeDict objectForKey:@"init_sig"] intValue];
			currentActivity.default_step = [(NSString *)[attributeDict objectForKey:@"default_step"] doubleValue];
			currentActivity.step_sig = [(NSString *)[attributeDict objectForKey:@"step_sig"] intValue];
			currentActivity.deleted = [(NSString *)[attributeDict objectForKey:@"deleted"] boolValue];
			
			currentActivity.created_on = [attributeDict objectForKey:@"created_on"];
			currentActivity.created_on_UTC = [attributeDict objectForKey:@"created_on_UTC"];
			currentActivity.modified_on = [attributeDict objectForKey:@"modified_on"];
			currentActivity.modified_on_UTC = [attributeDict objectForKey:@"modified_on_UTC"];
			
			activityNewer = YES;
		} else {
			activityNewer = NO;
		}
		
		currentActivity.public = NO;
		
		counts = [[NSMutableArray alloc] init];
	} else if ([elementName isEqualToString:@"group"]) {
		NSString *group = [attributeDict valueForKey:@"id"];
		if ([group isEqualToString:@"0"]) {
			currentActivity.public = YES;
		}
	} else if ([elementName isEqualToString:@"count"]) {
		TZCount *count = [[TZCount alloc] initWithGUID:[attributeDict valueForKey:@"guid"] andActivity:currentActivity];
		
		// if data is newer
		if (count.key == 0 ||
			[(NSString *)[attributeDict objectForKey:@"modified_on_UTC"] compare:count.modified_on_UTC] == NSOrderedDescending) {
			count.guid = [attributeDict objectForKey:@"guid"];
			count.note = [attributeDict objectForKey:@"note"];
			count.amount = [(NSString *)[attributeDict objectForKey:@"amount"] doubleValue];
			count.amount_sig = [(NSString *)[attributeDict objectForKey:@"amount_sig"] intValue];
			count.latitude = [(NSString *)[attributeDict objectForKey:@"latitude"] doubleValue];
			count.longitude = [(NSString *)[attributeDict objectForKey:@"longitude"] doubleValue];
			count.deleted = [(NSString *)[attributeDict objectForKey:@"deleted"] boolValue];
			
			count.created_on = [attributeDict objectForKey:@"created_on"];
			count.created_on_UTC = [attributeDict objectForKey:@"created_on_UTC"];
			count.modified_on = [attributeDict objectForKey:@"modified_on"];
			count.modified_on_UTC = [attributeDict objectForKey:@"modified_on_UTC"];
			
			[counts addObject:count];
		}
		
		[count release];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
	
	//NSLog(@"ended element: %@", elementName);
	if ([elementName isEqualToString:@"activity"]) {
		if (activityNewer) {
			// check for name conflict
			TZActivity *a = [[TZActivity alloc] initWithName:currentActivity.name];
			if (a.key != 0 &&
				a.key != currentActivity.key) {
				// rename existing one on iPhone
				int i = 2;
				NSString *newName = [NSString stringWithFormat:@"%@ %d", a.name, i];
				
				while ([TZActivity nameExists:newName]) {
					i++;
					newName = [NSString stringWithFormat:@"%@ %d", a.name, i];
				}
				
				a.name = newName;
				[a save];
			}
			[a release];
			
			[currentActivity saveRaw];
		}
		
		for (TZCount *count in counts) {
			count.activity = currentActivity;
			[count saveRaw];
		}
		
		[currentActivity release];
		[counts release];
	}
}

- (void)start {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	self.username = [defaults stringForKey:@"username"];
	
	NSError *error;
	self.password = [SFHFKeychainUtils getPasswordForUsername:username andServiceName:@"TallyZoo" error:&error];	
	
	// log current time for saving to last sync time
	[now release];
	now = [[NSDate alloc] init];
	
	self.lastSync = [defaults stringForKey:@"lastSync"];
	
	[self initSyncQueue];
	
	if ([self getServerUpdates]) {
		state = STATE_RECEIVING;
	} else {
		// Error
		[delegate syncerFailed:self];
	}
}

- (float)progress {
	return progress;
}

- (void)setProgress:(float)p {
	if (progress == p) {
		return;
	}
	
	progress = p;
	
	[delegate syncerUpdated:self];
}

- (void)dealloc {
	[username release];
	[password release];
	[lastSync release];
	[now release];
	[xmlParser release];
	
	[apiURL release];
	
	[super dealloc];
}

@end
