//
//  Syncer.h
//  TallyZoo Free
//
//  Created by Tienshiao Ma on 2/22/10.
//  Copyright 2010 Apple Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TZActivity.h"

@class Syncer;

@protocol SyncerDelegate <NSObject>
@optional
- (void)syncerUpdated:(Syncer *)s;
- (void)syncerCompleted:(Syncer *)s;
- (void)syncerFailed:(Syncer *)s;
@end

@interface Syncer : NSObject {
	NSString *lastSync;
	NSDate *now;
	int state;
	NSURLConnection *connection;
	NSMutableData *receivedData;
	NSMutableArray *syncQueue;
	int syncTotal;
	NSString *apiURL;
	
	NSXMLParser *xmlParser;
	TZActivity *currentActivity;
	BOOL activityNewer;
	NSMutableArray *counts;
	
	float progress;
	id<SyncerDelegate> delegate;
	NSString *message;
	
	NSString *username;
	NSString *password;
	
	BOOL synced;
}

#define STATE_RECEIVING 1
#define STATE_UPDATING 2

@property (nonatomic, retain) NSString *apiURL;
@property (nonatomic, retain) NSString *lastSync;
@property (assign, nonatomic) float progress;
@property (assign, nonatomic) int state;
@property (assign, nonatomic) id<SyncerDelegate> delegate;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, assign) BOOL synced;

- (void)start;

@end
