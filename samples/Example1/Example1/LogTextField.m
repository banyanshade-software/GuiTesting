//
//  LogTextField.m
//  Example1
//
//  Created by Daniel BRAUN on 07/03/2015.
//  Copyright (c) 2015 Daniel BRAUN. All rights reserved.
//

#import "LogTextField.h"

@implementation LogTextField

- (void) mouseDown:(NSEvent *)theEvent
{
    NSLog(@"mouseDown: %@\n", theEvent);
    [super mouseDown:theEvent];
}

- (void) mouseUp:(NSEvent *)theEvent
{
    NSLog(@"mouseUp: %@\n", theEvent);
    [super mouseUp:theEvent];
}



@end
