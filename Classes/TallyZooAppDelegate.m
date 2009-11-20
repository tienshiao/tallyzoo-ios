//
//  TallyZooAppDelegate.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TallyZooAppDelegate.h"
#import "GraphViewController.h"
#import "SyncViewController.h"
#import "MoreTableViewController.h"

@implementation TallyZooAppDelegate

@synthesize window;
@synthesize database;
@synthesize location;
@synthesize locationDelegate;
@synthesize use_gps;

- (void)initializeDefaults {
	float testValue = [[NSUserDefaults standardUserDefaults] floatForKey:@"delay_preference"];
	if (testValue == 0.0) {
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults =  [NSDictionary dictionaryWithObjectsAndKeys:
									  [NSNumber numberWithInt:0], @"behavior_preference",
									  [NSNumber numberWithFloat:1.5], @"delay_preference",
									  [NSNumber numberWithBool:YES], @"gps_preference",
									  nil];
		
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)initializeDatabase {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"tallyzoo.db"];
    success = [fileManager fileExistsAtPath:writableDBPath];
	if (!success) {
		// The writable database does not exist, so copy the default to the appropriate location.
		NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"tallyzoo.db"];
		success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
		if (!success) {
			NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
		}
	}
	
	database = [[FMDatabase databaseWithPath:writableDBPath] retain];
	if (![database open]) {
		NSAssert(0, @"Failed to open database.");
	}
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	self.location = newLocation;
	
	if (locationDelegate && [locationDelegate respondsToSelector:@selector(locationFound)]) { 
		[locationDelegate locationFound];
	}	
}

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self initializeDefaults];
	[self initializeDatabase];

	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	use_gps = [defaults boolForKey:@"gps_preference"];
	if (use_gps) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
		locationManager.distanceFilter = 20;
		locationManager.delegate = self;
		[locationManager startUpdatingLocation];
	}
	
	mvc = [[MatrixViewController alloc] init];
	UINavigationController *mnc = [[UINavigationController alloc] initWithRootViewController:mvc];
	mnc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Dashboard" image:[UIImage imageNamed:@"10-medical.png"] tag:1];
	
	GraphViewController *gvc = [[GraphViewController alloc] init];
	UINavigationController *gnc = [[UINavigationController alloc] initWithRootViewController:gvc];
	gnc.navigationBarHidden = YES;
	gnc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Graphs" image:[UIImage imageNamed:@"16-line-chart.png"] tag:2];
	[gvc release];
	
	SyncViewController *svc = [[SyncViewController alloc] init];
	UINavigationController *snc = [[UINavigationController alloc] initWithRootViewController:svc];
	snc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Sync" image:[UIImage imageNamed:@"02-redo.png"] tag:3];
	[svc release];
	
	MoreTableViewController *mtvc = [[MoreTableViewController alloc] init];
	UINavigationController *mtnc = [[UINavigationController alloc] initWithRootViewController:mtvc];
	mtnc.tabBarItem = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemMore tag:4];
	[mtvc release];
	
	tbController = [[TZTabBarController alloc] init];
	tbController.viewControllers = [NSArray arrayWithObjects:mnc, gnc, snc, mtnc, nil];
	tbController.view.backgroundColor = [UIColor blackColor];
	
	[mnc release];
	[gnc release];
	[snc release];
	[mtnc release];
	
	[window addSubview:tbController.view];
    [window makeKeyAndVisible];
	window.backgroundColor = [UIColor blackColor];
}

- (void)applicationWillTerminate:(UIApplication *)application {
	if (mvc.editting) {
		[mvc doneButtons:self];
	}
	
    // Close the database.
	[database close];
}

- (void)dealloc {
    [window release];

	[tbController release];
	[locationManager release];
	[location release];
	
	[super dealloc];

}


@end
