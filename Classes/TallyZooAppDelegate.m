//
//  TallyZooAppDelegate.m
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import "TallyZooAppDelegate.h"
#import "MatrixViewController.h"
#import "GraphViewController.h"

@implementation TallyZooAppDelegate

@synthesize window;
@synthesize database;

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

- (void)applicationDidFinishLaunching:(UIApplication *)application {
	[self initializeDatabase];
	
	MatrixViewController *mvc = [[MatrixViewController alloc] init];
	UINavigationController *mnc = [[UINavigationController alloc] initWithRootViewController:mvc];
	mnc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Count" image:[UIImage imageNamed:@"10-medical.png"] tag:1];
	[mvc release];
	
	GraphViewController *gvc = [[GraphViewController alloc] init];
	gvc.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Graph" image:[UIImage imageNamed:@"16-line-chart.png"] tag:2];
	
	UITabBarController *tbController = [[UITabBarController alloc] init];
	tbController.viewControllers = [NSArray arrayWithObjects:mnc, gvc, nil];
	
	[mnc release];
	[gvc release];
	
	[window addSubview:tbController.view];
    [window makeKeyAndVisible];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Close the database.
	[database close];
}

- (void)dealloc {
    [window release];
    [super dealloc];
}


@end
