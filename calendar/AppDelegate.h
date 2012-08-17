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
    IBOutlet NSView *timeView;
    IBOutlet NSTextField *timeField;
    IBOutlet NSButton *timeButton;
    IBOutlet NSButton *updateButton;
    
    NSInteger year;
    NSInteger month;
    NSInteger day;
    NSString *updateUrl;
}
@property (weak) IBOutlet NSPopover *popover;
@property (weak) IBOutlet NSWindow *window;
@property (weak) IBOutlet WebView *webView;
- (IBAction)openSina:(id)sender;
- (IBAction)openHome:(id)sender;
- (IBAction)updateClick:(id)sender;
@end
