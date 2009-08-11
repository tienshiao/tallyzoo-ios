//
//  CustomColorViewController.h
//  TallyZoo
//
//  Created by Tienshiao Ma on 8/11/09.
//  Copyright 2009 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomColorViewController : UITableViewController {
	UIColor *colorValue;
	id editedObject;
	NSString *editedFieldKey;
	
	UISlider *redSlider;
	UISlider *greenSlider;
	UISlider *blueSlider;
}

@property (nonatomic, retain) UIColor *colorValue;
@property (assign, nonatomic) id editedObject;
@property (copy, nonatomic) NSString *editedFieldKey;

@end
