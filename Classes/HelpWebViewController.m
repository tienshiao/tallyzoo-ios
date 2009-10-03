//
//  HelpWebViewController.m
//  ControlPad
//
//  Created by Tienshiao Ma on 11/16/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "HelpWebViewController.h"


@implementation HelpWebViewController

- (id)initWithFileNamed:(NSString *)filename {
	if (self = [super init]) {
		file = [filename copy];
		
		NSString *basePath = [[NSBundle mainBundle] resourcePath];
		basePath = [basePath stringByReplacingOccurrencesOfString:@"/" withString:@"//"];
		basePath = [basePath stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
		basePath = [NSString stringWithFormat:@"file:/%@//", basePath];
		
		webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
		webview.delegate = self;
		NSString *filePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:file];
		NSData *htmlData = [NSData dataWithContentsOfFile:filePath];
		[webview loadData:htmlData MIMEType:@"text/html" textEncodingName:@"UTF-8" 
				  baseURL:[NSURL URLWithString:basePath]]; 
				
		[self.view addSubview:webview];
	}
	
	return self;
}

- (id)initWithURL:(NSURL *)u {
	if (self = [super init]) {
		webview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
		webview.delegate = self;
		[webview loadRequest:[NSURLRequest requestWithURL:u]]; 
		
		[self.view addSubview:webview];
	}
	
	return self;
}


/*
// Implement loadView to create a view hierarchy programmatically.
- (void)loadView {	
}
*/
/*
// Implement viewDidLoad to do additional setup after loading the view.
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request 
	navigationType:(UIWebViewNavigationType)navigationType {
	if (navigationType == UIWebViewNavigationTypeLinkClicked &&
		![[request URL] isFileURL]) {
		[[UIApplication sharedApplication] openURL:[request URL]];
		return NO;
	}
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[file release];
    [super dealloc];
}


@end
