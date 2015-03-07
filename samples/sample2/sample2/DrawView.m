//
//  DrawView.m
//  sample2
//
//  Created by Daniel BRAUN on 07/03/2015.
//  Copyright (c) 2015 Daniel BRAUN. All rights reserved.
//

#import "DrawView.h"

@implementation DrawView {
    NSMutableArray *points;
}


- (void)drawRect:(NSRect)dirtyRect
{
    [super drawRect:dirtyRect];
    [[NSColor whiteColor]set];
    NSRectFill(dirtyRect);
    
    [[NSColor blueColor]set];
    for (NSValue *vp in points) {
        NSPoint p = [vp pointValue];
        NSRect r = NSMakeRect(p.x-2, p.y-2, 4, 4);
        NSRectFill(r);
    }
}

- (void) mouseDown:(NSEvent *)theEvent
{
    NSPoint p = [self convertPoint:theEvent.locationInWindow fromView:nil];
    NSLog(@"point at %fx%f\n", p.x, p.y);
    if (!points) points = [[NSMutableArray alloc]initWithCapacity:400];
    [points addObject:[NSValue valueWithPoint:p]];
    [self setNeedsDisplay:YES];
}

- (NSInteger) numberOfPoints
{
    return [points count];
}
@end
