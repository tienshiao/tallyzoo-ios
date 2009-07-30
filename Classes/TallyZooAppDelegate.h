//
//  TallyZooAppDelegate.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 7/23/09.
//  Copyright __MyCompanyName__ 2009. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMDatabase.h"

#define UIAppDelegate ((TallyZooAppDelegate *)[UIApplication sharedApplication].delegate)

@interface TallyZooAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
	
	FMDatabase *database;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) FMDatabase *database;

@end

