//
//  AppDelegate.h
//  Example1
//
//  Created by Daniel BRAUN on 07/03/2015.
//  Copyright (c) 2015 Daniel BRAUN. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (strong,nonatomic) NSNumber *a;
@property (strong,nonatomic) NSNumber *b;

@property (readonly,nonatomic) NSNumber *result;

@end

