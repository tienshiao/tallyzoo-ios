//
//  SyncViewController.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 9/2/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import "SyncViewController.h"
#import "TallyZooAppDelegate.h"
#import "FMDatabase.h"
#import "FMDatabaseAdditions.h"
#import "FMResultSet.h"
#import "UIColor-Expanded.h"
#import "AccountBackgroundView.h"
#import "SFHFKeychainUtils.h"
#import "TZCount.h"
#import "GTMNSString+XML.h"

@implementation SyncViewController

@synthesize apiURL;

- (id)init {
	if (self = [super init]) {
		self.title = @"Sync";

		self.apiURL = [[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"];
		if ([apiURL length] == 0) {
			self.apiURL = @"www.tallyzoo.com/api.php";
		}
	}
	return self;
}

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        // Custom initialization
    }
    return self;
}
*/


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	UIView *containerView = [[UIView alloc] init];
	containerView.backgroundColor = [UIColor blackColor];
	
	AccountBackgroundView *abv = [[AccountBackgroundView alloc] initWithFrame:CGRectMake(10, 20, 300, 71)];
	[containerView addSubview:abv];
	[abv release];
	
	usernameField = [[UITextField alloc] initWithFrame:CGRectMake(10, 7, 280, 30)];
	usernameField.placeholder = @"Username";
	usernameField.returnKeyType = UIReturnKeyDone;
	usernameField.delegate = self;
	[abv addSubview:usernameField];

	passwordField = [[UITextField alloc] initWithFrame:CGRectMake(10, 42, 280, 30)];
	passwordField.placeholder = @"Password";
	passwordField.secureTextEntry = YES;
	passwordField.returnKeyType = UIReturnKeyDone;
	passwordField.delegate = self;
	[abv addSubview:passwordField];
	
	lastLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 110, 280, 20)];
	lastLabel.textColor = [UIColor whiteColor];
	lastLabel.backgroundColor = [UIColor blackColor];
	lastLabel.font = [UIFont systemFontOfSize:14];
	[containerView addSubview:lastLabel];
	
	progressView = [[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleDefault];
	progressView.frame = CGRectMake(20, 110, 280, 20);
	progressView.progress = 0.0;
	progressView.hidden = YES;
	[containerView addSubview:progressView];
	
	syncButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	syncButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
	[syncButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
	syncButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[syncButton setTitle:@"Sync Now" forState:UIControlStateNormal];
	
/*	UIImage *image = [UIImage imageNamed:@"red_up.png"];
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[deleteButton setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *imagePressed = [UIImage imageNamed:@"red_down.png"];
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[deleteButton setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];*/
	
	syncButton.frame = CGRectMake(10, 140, 300, 40);
	[syncButton addTarget:self action:@selector(sync:) forControlEvents:UIControlEventTouchUpInside];

	[containerView addSubview:syncButton];

	signupButton = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	signupButton.titleLabel.font = [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]];
	[signupButton setTitleShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5] forState:UIControlStateNormal];
	signupButton.titleLabel.shadowOffset = CGSizeMake(0, -1);
	[signupButton setTitle:@"Sign Up for a Free Account" forState:UIControlStateNormal];	
	signupButton.frame = CGRectMake(10, 190, 300, 40);
	[signupButton addTarget:self action:@selector(signup:) forControlEvents:UIControlEventTouchUpInside];
	[containerView addSubview:signupButton];
	
	self.view = containerView;
	
	[containerView release];
}


/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (void)viewWillAppear:(BOOL)animated {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	usernameField.text = [defaults stringForKey:@"username"];
	original_username = [usernameField.text copy];
	
	NSError *error;
	passwordField.text = [SFHFKeychainUtils getPasswordForUsername:usernameField.text andServiceName:@"TallyZoo" error:&error];

	[lastSync release];
	lastSync = [[defaults stringForKey:@"lastSync"] copy];
	
	if (lastSync) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		NSDate *temp = [df dateFromString:lastSync];
		lastLabel.text = [NSString stringWithFormat:@"Last Synced: %@", temp];
		[df release];
	} else {
		lastLabel.text = @"Last Synced: never";
	}	
}

- (void)viewWillDisappear:(BOOL)animated {
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:usernameField.text forKey:@"username"];
	
	[defaults synchronize];

	NSError *error;
	if (![original_username isEqualToString:usernameField.text]) {
		[SFHFKeychainUtils deleteItemForUsername:original_username andServiceName:@"TallyZoo" error:&error];
	}
	
	[SFHFKeychainUtils storeUsername:usernameField.text andPassword:passwordField.text forServiceName:@"TallyZoo" updateExisting:YES error:&error];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)signup:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.tallyzoo.com/register"]];
}

- (void)sync:(id)sender {
	// TODO set up UI
	[usernameField resignFirstResponder];
	[passwordField resignFirstResponder];
	syncButton.enabled = NO; 
	lastLabel.hidden = YES;
	progressView.hidden = NO;
	progressView.progress = 0.0;
	
	// log current time for saving to last sync time
	[now release];
	now = [[NSDate alloc] init];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[lastSync release];
	lastSync = [[defaults stringForKey:@"lastSync"] copy];

	if ([self getServerUpdates]) {
		state = STATE_RECEIVING;
	} else {
		// Error
		
		[self syncCleanUp];
	}
}

- (void)syncCleanUp {
	syncButton.enabled = YES;
	progressView.progress = 1.0;
	progressView.hidden = YES;
	lastLabel.hidden = NO;

	if (lastSync) {
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		NSDate *temp = [df dateFromString:lastSync];	
		lastLabel.text = [NSString stringWithFormat:@"Last Synced: %@", temp];
		[df release];
	} else {
		lastLabel.text = @"Last Synced: never";
	}
}

- (NSString *)getCurrentDBTime {
	FMDatabase *dbh = UIAppDelegate.database;
	return [dbh stringForQuery:@"SELECT datetime('now')"];
}

- (BOOL)getServerUpdates {
	NSString *urlString = [NSString stringWithFormat:@"http://%@:%@@%@/activities.list", usernameField.text, passwordField.text, apiURL];
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
		progressView.progress = 0.02;
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
		
		// TODO update last sync date/time
		NSDateFormatter *df = [[NSDateFormatter alloc] init];
		[df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
		[df setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
		[lastSync release];
		lastSync = [[df stringFromDate:now] copy];
		[df release];
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[defaults setObject:lastSync forKey:@"lastSync"];
		[defaults synchronize];
		
		
		// TODO clean up UI, etc
		[self syncCleanUp];
		
		[syncQueue release];
		syncQueue = nil;
		
		return;
	}
	
	NSObject *o = [syncQueue objectAtIndex:0];
	
	NSString *urlString;
	NSString *body;
	if ([o isKindOfClass:[TZActivity class]]) {
		urlString = [NSString stringWithFormat:@"http://%@:%@@%@/activities.update", usernameField.text, passwordField.text, apiURL];
		body = [self buildActivityXML:(TZActivity *)o];
	} else {
		urlString = [NSString stringWithFormat:@"http://%@:%@@%@/counts.update", usernameField.text, passwordField.text, apiURL];
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
		
		// clean up UI, etc
		[self syncCleanUp];
	}		
}

- (void)updateServer {
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
	
	[self sendNextUpdate];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
	// make sure we get back a 200
	NSHTTPURLResponse *r = (NSHTTPURLResponse *)response;
	if ([r statusCode] != 200) {
		NSLog(@"connection failed with %d", [r statusCode]);
		state = 0;
		
		if ([r statusCode] == 401) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Authentication Failed" 
															message:@"Unable to login. Please double check your username and password, and that your account has been activated via the email confirmation." 
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert autorelease];
		} else {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error Syncing" 
															message:@"An error occurred while syncing. Please try again later." 
														   delegate:nil
												  cancelButtonTitle:@"OK" 
												  otherButtonTitles:nil];
			[alert show];
			[alert autorelease];			
		}
		
		// clean up UI
		[self syncCleanUp];
	}
	receivedData = [[NSMutableData alloc] init];
	[receivedData setLength:0];
	progressView.progress = progressView.progress + 0.05;

}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	NSString *body = [[NSString alloc] initWithBytes:[receivedData bytes] 
											  length:[receivedData length] 
											encoding:NSUTF8StringEncoding];
	//NSLog(body);
	
	if (state == STATE_RECEIVING) {
		progressView.progress = .15;
		// parse activities
		[self parseActivities];
		progressView.progress = .3;
		
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
		
		progressView.progress = .3 + ((float) (syncTotal - [syncQueue count])) / syncTotal * .7;
	}	
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
	syncButton.enabled = YES;
	progressView.progress = 1.0;
	progressView.hidden = YES;
	lastLabel.hidden = NO;
	
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sync Failed" 
													message:[NSString stringWithFormat:@"Unable to connect to server (%@). Please try again later.", [error localizedDescription]] 
												   delegate:nil
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	[alert show];
	[alert autorelease];	
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[original_username release];
	[usernameField release];
	[passwordField release];
	[progressView release];
	[syncButton release];
	[signupButton release];
	
	[lastLabel release];
	[lastSync release];
	[now release];
	[xmlParser release];
	
	[apiURL release];
	
	[super dealloc];
}


@end
