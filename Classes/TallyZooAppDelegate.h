//
//  TallyZooAppDelegate.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "FMDatabase.h"

#define UIAppDelegate ((TallyZooAppDelegate *)[UIApplication sharedApplication].delegate)

@interface TallyZooAppDelegate : NSObject <UIApplicationDelegate, CLLocationManagerDelegate> {
    UIWindow *window;
	
	FMDatabase *database;
	CLLocationManager *locationManager;
	CLLocation *location;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) FMDatabase *database;
@property (nonatomic, retain) CLLocation *location;

@end

