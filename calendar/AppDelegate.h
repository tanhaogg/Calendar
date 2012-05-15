//
//  AppDelegate.h
//  calendar
//
//  Created by 楚江 王 on 12-4-13.
//  Copyright (c) 2012年 http://www.tanhao.me All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>{
    IBOutlet NSStatusItem *statusItem;
    NSButton *dockIconSelector;
    
}
@property (assign) IBOutlet NSPopover *popover;
@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet WebView *webView;
- (IBAction)openSina:(id)sender;

@end
