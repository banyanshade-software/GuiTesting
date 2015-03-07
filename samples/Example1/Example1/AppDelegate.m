//
//  AppDelegate.m
//  Example1
//
//  Created by Daniel BRAUN on 07/03/2015.
//  Copyright (c) 2015 Daniel BRAUN. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

@synthesize a = _a;
@synthesize b = _b;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    self.a = @2;
    self.b = @2;

    // for event playground / recording / etc...
    if ((0)) {
        // http://stackoverflow.com/questions/28916732/capture-other-mouse-button-events-on-os-x-with-nsevent
        // CGEventTapCreate may be better ?
        [NSEvent addGlobalMonitorForEventsMatchingMask: NSEventMaskFromType(NSLeftMouseDown)|NSEventMaskFromType(NSLeftMouseUp)
                                               handler:^(NSEvent *event) {
                                                   NSLog(@"*** Mouse: %@", event);
                                               }];

    }
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


+ (NSSet *) keyPathsForValuesAffectingResult
{
    return [NSSet setWithObjects:@"a", @"b", nil];
}

- (NSNumber *) result
{
    NSNumber *r = [NSNumber numberWithDouble:[_a doubleValue]+[_b doubleValue]];
    return r;
}
@end
