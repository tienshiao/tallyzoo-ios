//
//  HelpWebViewController.h
//  ControlPad
//
//  Created by Tienshiao Ma on 11/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpWebViewController : UIViewController <UIWebViewDelegate>{
	NSString *file;
	UIWebView *webview;
}

- (id)initWithFileNamed:(NSString *)filename;
- (id)initWithURL:(NSURL *)u;

@end
