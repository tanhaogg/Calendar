//
//  AppDelegate.m
//  calendar
//
//  Created by 楚江 王 on 12-4-13.
//  Copyright (c) 2012年 http://www.tanhao.me All rights reserved.
//

#import "AppDelegate.h"
#import "THWebService.h"

@interface NSStatusBar(Private)
- (id)_statusItemWithLength:(double)length withPriority:(int)priority;
@end

@implementation AppDelegate

@synthesize window,popover,webView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    if ([statusBar respondsToSelector:@selector(_statusItemWithLength:withPriority:)])
    {
        statusItem = (NSStatusItem*)[statusBar _statusItemWithLength:NSWidth(timeView.frame) withPriority:INT_MAX-1];
    }else
    {
        statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    }
    statusItem.highlightMode=YES;
    NSImage *imageStatus=[NSImage imageNamed:@"status.png"];
    statusItem.image=imageStatus;
    [timeButton setTarget:self];
    [timeButton setAction:@selector(showInfoPopover:)];
    [statusItem setView:timeView];
    
    [[self window] setBackgroundColor:[NSColor blueColor]];
    [NSTimer scheduledTimerWithTimeInterval: 0.5
                                     target: self
                                   selector: @selector(timerAction:)
                                   userInfo: nil
                                    repeats: YES];
    [self timerAction:nil];
    
    //注册为开机启动
    LSSharedFileListRef loginItems = LSSharedFileListCreate(NULL, kLSSharedFileListSessionLoginItems, NULL);
    NSString *appPath = [[NSBundle mainBundle] executablePath];
    appPath = [[NSBundle mainBundle] bundlePath];
    CFURLRef url = (__bridge CFURLRef)[NSURL fileURLWithPath:appPath];
	LSSharedFileListItemRef item = LSSharedFileListInsertItemURL(loginItems, kLSSharedFileListItemLast, NULL, NULL, url, NULL, NULL);
	CFRelease(item);
    CFRelease(loginItems);
    
    //检测更新
    [self updateCheck];
    THWebService *webwervice = [[THWebService alloc] init];
    webwervice.url = [NSURL URLWithString:@"http://myconfig.sinaapp.com/calendar/info.php"];
    [webwervice startWithHandler:^(NSURLResponse *response, NSError *error, NSData *data) {
        if (data)
        {
            //NSDictionary *info = [[CJSONDeserializer deserializer] deserializeAsDictionary:data error:&error];
            NSDictionary *info = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            if (info)
            {
                [[NSUserDefaults standardUserDefaults] setObject:info forKey:@"info"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [self updateCheck];
            }
        }
    }];
}

- (void)updateCheck
{
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSDictionary *info = [[NSUserDefaults standardUserDefaults] objectForKey:@"info"];
    if (info)
    {
        updateUrl = [info objectForKey:@"downloadurl"];
        NSString *latestVersion = [info objectForKey:@"version"];
        
        NSArray *currentVersionComponent = [currentVersion componentsSeparatedByString:@"."];
        NSArray *latestVersionComponent = [latestVersion componentsSeparatedByString:@"."];
        
        BOOL isLatest = YES;
        for (int i=0;i<[latestVersionComponent count];i++)
        {
            if ([currentVersionComponent count]<i+1)
            {
                if ([[latestVersionComponent objectAtIndex:i] intValue] > 0)
                {
                    isLatest = NO;
                    break;
                }
            }
            else if ([[currentVersionComponent objectAtIndex:i] intValue] < [[latestVersionComponent objectAtIndex:i] intValue])
            {
                isLatest = NO;
                break;
            }
            else if ([[currentVersionComponent objectAtIndex:i] intValue] > [[latestVersionComponent objectAtIndex:i] intValue])
            {
                break;
            }
        }
        
        if (!isLatest)
        {
            [updateButton setHidden:NO];
        }else {
            [updateButton setHidden:YES];
        }
    }
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
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://weibo.com/writecodes"]];
}

- (IBAction)openHome:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://www.tanhao.me"]];
}

- (IBAction)updateClick:(id)sender
{
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:updateUrl]];
}

-(IBAction)timerAction:(id)sender
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit calendarUnit = NSSecondCalendarUnit|NSWeekdayCalendarUnit|NSMinuteCalendarUnit|NSHourCalendarUnit|NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;
    NSDateComponents *dateComponents = [calendar components:calendarUnit fromDate:[NSDate date]];
    
    NSInteger currentYear = [dateComponents year];
    NSInteger currentMonth = [dateComponents month];
    NSInteger currentDay = [dateComponents day];
    
    NSInteger currentHour = [dateComponents hour];
    NSInteger currentMinute = [dateComponents minute];
    NSInteger currentSecond = [dateComponents second];
    NSInteger currentWeek = [dateComponents weekday];
    
    NSString *allWeeks[] = {@"日",@"一",@"二",@"三",@"四",@"五",@"六"};
    
    NSString *timeString = [NSString stringWithFormat:@"%02ld%@%02ld %@",currentHour,currentSecond%2?@" ":@":",currentMinute,allWeeks[currentWeek-1]];
    [timeField setStringValue:timeString];
    
    if ((year&month&day == 0)
        || (year!=currentYear)
        || (month!=currentMonth)
        || (day!=currentDay))
    {
        year = currentYear;
        month = currentMonth;
        day = currentDay;
        timeButton.image=[NSImage imageNamed:[NSString stringWithFormat: @"status%lu.png",day]];
        
        //刷新网页
        if (![[self popover] isShown])
        {
            NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
            NSString *htmlPath = [resourcesPath stringByAppendingString:@"/calendarHTML/test.html"];
            [[webView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:htmlPath]]];
            [webView setDrawsBackground:NO];
        }
    }
}
@end
