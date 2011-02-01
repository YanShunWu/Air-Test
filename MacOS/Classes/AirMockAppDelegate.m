//
//  AirMockAppDelegate.m
//  AirMock
//
//  Created by 徐 楽楽 on 11/01/30.
//  Copyright 2011 RakuRaku Technologies. All rights reserved.
//

#import "AirMockAppDelegate.h"
#import "AMHTTPConnection.h"

@implementation AirMockAppDelegate

@synthesize window, dropView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// Insert code here to initialize your application 
	httpServer = [[ThreadPoolServer alloc] init];
//    httpServer = [[HTTPServer alloc] init];
    
	// Set the bonjour type of the http server.
	// This allows the server to broadcast itself via bonjour.
	// You can automatically discover the service in Safari's bonjour bookmarks section.
	[httpServer setType:@"_airmock._tcp."];
    [httpServer setConnectionClass:[AMHTTPConnection class]];
	
	// Serve files from the standard Sites folder
//	[httpServer setDocumentRoot:[NSURL fileURLWithPath:[@"~/Sites" stringByExpandingTildeInPath]]];
	
	NSError *error;
	BOOL success = [httpServer start:&error];
	
	if(!success)
	{
		NSLog(@"Error starting HTTP Server: %@", error);
	}
    
//    NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//    NSString *root = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) objectAtIndex:0];
//	
//	httpServer = [HTTPServer new];
//	[httpServer setType:@"_http._tcp."];
//	
//	[httpServer setDocumentRoot:[NSURL fileURLWithPath:root]];
    
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    NSLog(@"exiting");
    [httpServer stop];
    [httpServer release];
    exit(3);
}

- (void)application:(NSApplication *)sender openFiles:(NSArray *)filenames {
    for (NSString *fileName in filenames) {
        if ([fileName hasSuffix:@".app"] || [fileName hasSuffix:@".ipa"]) {
            [dropView openFile:fileName];
            break;
        }
    }
}

@end
