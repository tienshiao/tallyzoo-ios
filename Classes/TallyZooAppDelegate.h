//
//  TallyZooAppDelegate.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "TZTabBarController.h"
#import "FMDatabase.h"
#import "MatrixViewController.h"
#import "Syncer.h"

#define UIAppDelegate ((TallyZooAppDelegate *)[UIApplication sharedApplication].delegate)

@interface TallyZooAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
	TZTabBarController *tbController;
	MatrixViewController *mvc;
	
	FMDatabase *database;
	CLLocationManager *locationManager;
	CLLocation *location;
	id locationDelegate;
	BOOL use_gps;
	
	Syncer *syncer;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) CLLocation *location;
@property (nonatomic, assign) id locationDelegate;
@property (nonatomic, assign) BOOL use_gps;
@property (nonatomic, retain) Syncer *syncer;

- (void)initializeDatabase;

@end

