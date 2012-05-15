//
//  AppDelegate.m
//  calendar
//
//  Created by 楚江 王 on 12-4-13.
//  Copyright (c) 2012年 http://www.tanhao.me All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window,popover,webView;

- (void)dealloc
{
    [super dealloc];
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    statusItem = [[[NSStatusBar systemStatusBar] statusItemWithLength:NSVariableStatusItemLength] retain];
    statusItem.highlightMode=YES;
    NSImage *imageStatus=[NSImage imageNamed:@"status.png"];
    statusItem.image=imageStatus;
    [statusItem setAction:@selector(showInfoPopover:)];
    
    [[self window] setBackgroundColor:[NSColor blueColor]];
    
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
	NSString *htmlPath = [resourcesPath stringByAppendingString:@"/calendarHTML/test.html"];
	[[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]]; 
    [webView setDrawsBackground:NO];
    
    [NSTimer scheduledTimerWithTimeInterval: 60
                                     target: self
                                   selector: @selector(timerAction:)
                                   userInfo: nil
                                    repeats: YES];
    [self timerAction:nil];
    
    //注册为开机启动
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *appPath = [[NSBundle mainBundle] executablePath];
    CFURLRef url = (CFURLRef)[NSURL fileURLWithPath:appPath];
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
	CFRelease(item);
    CFRelease(loginItems);
}

-(IBAction)showInfoPopover:(id)sender
{
    [[self popover] showRelativeToRect:[sender bounds] ofView:sender preferredEdge:NSMaxYEdge];
}

- (IBAction)quitApp:(id)sender 
{
    [NSApp terminate:sender];
}

- (IBAction)openSina:(id)sender 
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://weibo.com/pc175"]];
}

-(IBAction)timerAction:(id)sender
{
    //获取当前日期
    NSDate *nows =[NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [gregorian components:NSDayCalendarUnit fromDate:nows];
    [gregorian release];
    NSInteger day=[dateComponents day];      
    statusItem.image=[NSImage imageNamed:[NSString stringWithFormat: @"status%lu.png",day]];
    
}
@end
