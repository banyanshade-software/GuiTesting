//
//  DbnTestSupport.m
//  SmartBank
//
//  Created by Daniel BRAUN on 14/10/2014.
//  Copyright (c) 2014 Daniel BRAUN. All rights reserved.
//
/*
 Copyright 2014-2015 Daniel Braun
 All rights reserved.
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of
 this software and associated documentation files (the "Software"), to deal in
 the Software without restriction, including without limitation the rights to
 use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 the Software, and to permit persons to whom the Software is furnished to do so,
 subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
 FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
 IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
 CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
*/

#import "GUITestSupport.h"
#import <Cocoa/Cocoa.h>
#import <AppKit/NSEvent.h>

@interface NSView (TestText)
- (NSString *) testText;
@end



@implementation NSView (TestText)


- (NSString *) testText
{
    NSString *txt;
    
    if (0) {
    } else if ([self respondsToSelector:@selector(attributedTitle)]) {
        NSAttributedString *as = [self performSelector:@selector(attributedTitle)];
        txt = [as string];
    } else if ([self respondsToSelector:@selector(title)]) {
        txt = [self performSelector:@selector(title)];
    } // .. more todo
    if (!txt) txt=@"";
    return txt;
}
@end

@interface NSTextField (TestText)
- (NSString *) testText;
@end

@implementation NSTextField (TestText)
- (NSString *) testText
{
    NSString *txt = [self stringValue];
    return txt;
}
@end


@implementation NSView (Tests)


- (NSView *) findSuperViewOfClass:(Class)c
{
    for (NSView *v = self; v; v = [v superview]) {
        if ([v isKindOfClass:c]) return v;
    }
    return nil;
}

- (NSView *) findSubviewOfClass:(Class)c havingText:(NSString *)text
{
    if ([self isKindOfClass:c]) {
        if (!text || [[self testText]isEqualToString:text]) return self;
    }
    NSArray *sub = [self subviews];
    for (NSView *v in sub) {
        NSView *f = [v findSubviewOfClass:c havingText:text];
        if (f) return f;
    }
    return nil;
}

- (NSArray<NSView *>*) findAllSubviewsOfClass:(Class)c havingText:(NSString *)text
{
    NSArray *r = nil;
    if ([self isKindOfClass:c]) {
        if (!text || [[self testText]isEqualToString:text]) r = @[self];
    }
    if (!r) r = @[];
    NSArray *sub = [self subviews];
    for (NSView *v in sub) {
        NSArray *t = [v findAllSubviewsOfClass:c havingText:text];
        if ([t count]) r = [r arrayByAddingObjectsFromArray:t];
    }
    return r;
}

- (NSView *) findSubviewOfClass:(Class)c havingTextPrefix:(NSString *)text
{
    if ([self isKindOfClass:c]) {
        if (!text || [[self testText]hasPrefix:text]) return self;
    }
    NSArray *sub = [self subviews];
    for (NSView *v in sub) {
        NSView *f = [v findSubviewOfClass:c havingTextPrefix:text];
        if (f) return f;
    }
    return nil;
}

@end


@implementation NSView (Testing)

// inspired from http://www.cocoawithlove.com/2008/11/automated-user-interface-testing-on.html?m=1

- (NSDictionary *)testDescription
{
#if 0
    NSDictionary *frame =
    [NSDictionary dictionaryWithObjectsAndKeys:
     [NSNumber numberWithFloat:self.frame.origin.x], @"x",
     [NSNumber numberWithFloat:self.frame.origin.y], @"y",
     [NSNumber numberWithFloat:self.frame.size.width], @"width",
     [NSNumber numberWithFloat:self.frame.size.height], @"height",
     nil];
#endif
    
    if ([[self className]isEqual:@"BSSUI_ToolbarButton"]) {
       //NSLog(@"bjk\n");
    }
    NSString *txt = [self testText];
    NSString *vaid = [self accessibilityIdentifier];
    if (!vaid && [self isKindOfClass:[NSControl class]]) {
        // accessibility is in cell
        id sub =  NSAccessibilityUnignoredDescendant(self);
        vaid = [sub accessibilityIdentifier];
        if (vaid) {
            //NSLog(@"got vaid %@ for %@\n", vaid, self);
        }
    } else if (vaid) {
        NSLog(@"vaid %@\n", vaid);
    }
    if (!vaid) vaid = @"";

    
    NSDictionary *description =
    [NSDictionary dictionaryWithObjectsAndKeys:
        [NSNumber numberWithInteger:(NSInteger)self], @"address",
        NSStringFromClass([self class]), @"className",
        //frame, @"frame",
        [NSNumber numberWithInteger:[self tag]], @"tag",
        txt, @"text",
        vaid, @"aid",
        [self valueForKeyPath:@"subviews.testDescription"], @"subviews",
     nil];
   
      return description;
}

@end


@implementation NSWindow (Testing)

- (NSDictionary *) testDescription
{
    NSWindow *vs = self.attachedSheet;
    if (vs) {
        return [vs testDescription];
    }
    NSView *v = self.contentView;
    return [v testDescription];
}

@end

static NSView *checkDic(NSDictionary *testdesc, NSString *className, NSString *str, int tag)
{
    int vtag = [[testdesc objectForKey:@"tag"]intValue];
    NSString *vtxt = [testdesc objectForKey:@"text"];
    NSString *vaid = [testdesc objectForKey:@"aid"];
    NSString *vclassName = [testdesc objectForKey:@"className"];
    if (str) {
        NSRange r = [vtxt rangeOfString:str];
        NSRange r2 = [vaid rangeOfString:str];
        if ((r.location == NSNotFound) && (r2.location == NSNotFound)) return nil;
    }
    if ((tag !=-1) && (tag != vtag)) return nil;
    if (className && ![className isEqualToString:vclassName]) return nil;
    // match;
    
    NSNumber *na = [testdesc objectForKey:@"address"];
    NSInteger ta = [na integerValue];
    void *vta = (void *)ta;
    return (__bridge NSView *) vta;
}

static NSView *testFindView(NSDictionary *testdesc, NSString *className, NSString *str, int tag)
{
    NSView *r = checkDic(testdesc, className, str, tag);
    if (r) return r;
    NSArray *s = [testdesc objectForKey:@"subviews"];
    for (NSDictionary *d in s) {
        r = testFindView(d, className, str, tag);
        if (r) return r;
    }
    return nil;
}

#pragma mark -

@implementation XCTestCaseGUI {
    NSDictionary *curdesc;
    NSWindow *mainWindow;
}


+ (BOOL) needActivate
{
    return YES;
}

- (void)setUp {
    [super setUp];
    if ([[self class]needActivate]) {
        [self activateAndWaitAppActive];
    }
    
}

- (void) waitUntil:(BOOL(^)(void))cond
{
    curdesc = nil;
    NSRunLoop *r = [NSRunLoop mainRunLoop];
    CFStringRef mode = (CFStringRef) CFBridgingRetain([r currentMode]);
    if (!mode) mode = kCFRunLoopDefaultMode;
    for (;;) {
        if (cond()) break;
        CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.5, false);
        [self consumeEvents];
        //[r runUntilDate:[NSDate dateWithTimeIntervalSinceNow:0.5]];
    }
}

- (NSWindow *) curWindow
{
    if (mainWindow) return mainWindow;
    NSWindow *w = [[NSApplication sharedApplication]mainWindow];
    NSWindow *w1 = [[NSApplication sharedApplication]keyWindow];
    NSLog(@"w %@ w1 %@\n", w, w1);
    mainWindow = w;
    return mainWindow;
}


- (NSDictionary *) currentDescription
{
    if (!curdesc) {
        NSWindow *w = [self curWindow];
        curdesc = [w testDescription];
    }
    return curdesc;
}

- (void) sleep:(NSTimeInterval)duration
{
    curdesc = nil;
    NSLog(@"test waiting %f seconds\n", duration);
#if 0
    NSRunLoop *r = [NSRunLoop mainRunLoop];
    [r runUntilDate:[NSDate dateWithTimeIntervalSinceNow:duration]];
#else
    NSDate *ed = [NSDate dateWithTimeIntervalSinceNow:duration];
    [self waitUntil:^BOOL{
        if ([[NSDate date] compare:ed]==NSOrderedDescending) return YES;
        return NO;
    }];
#endif
    NSLog(@"resume test\n");
}

- (NSView *)findViewOfClass:(NSString*)classname string:(NSString *)str_or_nil tag:(int)tag_or_minus1
{
    if (!curdesc) {
        NSWindow *w = [self curWindow];
        curdesc = [w testDescription];
    }
    return testFindView(curdesc, classname, str_or_nil, tag_or_minus1);
}

- (void) resetMainWindow
{
    curdesc=nil;
    mainWindow = nil;
}

- (NSString *) mainWindowTitle
{
    return nil;
}

- (void) activateAndWaitAppActive
{
    NSString *mwt = [self mainWindowTitle];
    [self resetMainWindow];
    NSApplication *app = [NSApplication sharedApplication];
    if (![app isActive]) {
        //[app activateIgnoringOtherApps:YES];
    }
    
    
    NSArray *ws = [app windows];
    NSLog(@"ws : %@\n", ws);
    NSWindow *mw = nil;
    for (NSWindow *w in ws) {
        [w makeKeyAndOrderFront:nil];
        if ([[w className] isEqualToString:@"NSComboBoxWindow"]) continue;
        if (mwt && ![[w title] isEqualToString:mwt]) continue;
        mw = w;
        break;
    }
    //[mw enableFlushWindow];
    //[mw flushWindow];
    //NSApplicationActivationPolicy ap = [app activationPolicy];
    //NSLog(@"ap %ld\n", ap);
    [mw orderBack:self];
    [mw orderFront:self];
    [mw orderFrontRegardless];
    mainWindow = mw;
    [self waitAppActive];
    //[self sleep:1.0];
}
- (void) waitAppActive
{
    if (![[self class]needActivate]) {
        [self resetMainWindow];
        return;
    }

    NSApplication *app = [NSApplication sharedApplication];
    NSWindow *mw = mainWindow;
    [self resetMainWindow];
    if ([app isActive]) return;
    [app unhide:self];
    [app activateIgnoringOtherApps:YES];
    [self waitUntil:^() {
        NSLog(@"check active\n");
        if ([app isActive]) return YES;
        //[mw makeMainWindow];
        //[mw makeKeyWindow];
        [mw makeKeyAndOrderFront:nil];
        return NO;
    }];
    [self resetMainWindow];
}

#pragma mark - highlevel actions

- (void) clickButton:(NSButton *)b
{
    XCTAssert([b isKindOfClass:[NSButton class]]);
    XCTAssert(b.isHidden == NO, @"attempt to click on hidden button");
    XCTAssert(b.isEnabled, @"attempt to click on disabled button");
    // - (BOOL)sendAction:(SEL)theAction to:(id)theTarget
    SEL act = b.action;
    id targ = b.target;
    if (!act || !targ) {
        XCTAssert(0, @"button has no action");
    }
    [b sendAction:act to:targ];
    curdesc = nil;
}

- (void) setField:(NSTextField *)f string:(NSString *)s
{
    [f setValue:s forKey:@"stringValue"];
    //[f resignFirstResponder];
    //[f validateEditing];
    NSDictionary *bindingInfo = [f infoForBinding: NSValueBinding];
    [[bindingInfo valueForKey: NSObservedObjectKey] setValue: f.stringValue
                                                  forKeyPath: [bindingInfo valueForKey: NSObservedKeyPathKey]];
    curdesc = nil;
    [self sleep:0.2];
}

#pragma mark - lowlevel actions

- (void) consumeEvents
{
    // http://www.cocoabuilder.com/archive/cocoa/228473-receiving-user-events-from-within-an-nstimer-callback.html
    NSEvent *event;
    while ((event = [NSApp nextEventMatchingMask: NSAnyEventMask untilDate:nil inMode:NSEventTrackingRunLoopMode dequeue:YES])) {
        [NSApp sendEvent: event];
    }
}

- (void) sendMouseClickToControl:(NSView *)ctrl
{
    [self sendMouseClickToControl:ctrl onRight:NO onLeft:NO];
}
- (void) sendMouseClickToControl:(NSView *)ctrl onRight:(BOOL)onright
{
    [self sendMouseClickToControl:ctrl onRight:onright onLeft:NO];
}

- (void) sendMouseClickToControl:(NSView *)ctrl onLeft:(BOOL)onleft
{
    [self sendMouseClickToControl:ctrl onRight:NO onLeft:onleft];
}



- (void) sendMouseClickToControl:(NSView *)ctrl onRight:(BOOL)onright onLeft:(BOOL)onleft
{
    NSRect r = [ctrl bounds];
    NSPoint p;
    if (onright) {
        p = NSMakePoint(NSMaxX(r)-1, NSMidY(r));
    } else if (onleft) {
        p = NSMakePoint(NSMinX(r)+1, NSMidY(r));
    } else {
        p = NSMakePoint(NSMidX(r), NSMidY(r));
    }
    // convert to window coord
    NSPoint pw = [ctrl convertPoint:p toView:nil];
    NSWindow *w = [ctrl window];
    NSInteger wnum = w.windowNumber;
    
    // http://lists.apple.com/archives/cocoa-dev/2011/Jan/msg00736.html
    static int cnt = 1234;
    
    NSEvent *eventDn = [NSEvent mouseEventWithType:NSLeftMouseDown location:pw modifierFlags:0 timestamp:[NSDate timeIntervalSinceReferenceDate]-0.002 windowNumber:wnum context:[NSGraphicsContext currentContext] eventNumber:cnt++ clickCount:1 pressure:1.0];
    NSEvent *eventUp = [NSEvent mouseEventWithType:NSLeftMouseUp location:pw modifierFlags:0 timestamp:[NSDate timeIntervalSinceReferenceDate]+0.00 windowNumber:wnum context:[NSGraphicsContext currentContext] eventNumber:cnt++ clickCount:1 pressure:1.0];

    if ((1)) {
        [NSApp postEvent:eventDn atStart:NO];
        //usleep(1000);
        [NSApp postEvent:eventUp atStart:NO];
    } else {
        //usleep(2000);
        [NSApp sendEvent:eventDn];
        //usleep(2000);
        [NSApp sendEvent:eventUp];
    }
    //[ctrl becomeFirstResponder];
    [self consumeEvents];
}

- (void) sendKeyboard:(NSString *)chars toControl:(NSControl *)ctrl
{
    //BOOL fr = [ctrl becomeFirstResponder];
    //XCTAssert(fr, @"control cannot become first responder");
    //if ((0)) return;
    NSRect r = [ctrl bounds];
    NSPoint p = NSMakePoint(NSMidX(r), NSMidY(r));
    // convert to window coord
    NSPoint pw = [ctrl convertPoint:p toView:nil];
    NSWindow *w = [ctrl window];
    NSInteger wnum = w.windowNumber;
    NSUInteger len = [chars length];
    for (NSUInteger i=0; i<len; i++) {
        unichar c = [chars characterAtIndex:i];
        NSString *cs = [NSString stringWithCharacters:&c length:1];
        // http://forums.macrumors.com/showthread.php?t=780577
        unsigned short keycode = 0;
        if ((0) && (c == '\n')) {
            keycode = 0x24;
        }
        NSEvent *eventDn = [NSEvent keyEventWithType:NSKeyDown location:pw modifierFlags:0 /*NSEventModifierFlags*/ timestamp:[NSDate timeIntervalSinceReferenceDate] windowNumber:wnum context:[NSGraphicsContext currentContext] characters:cs charactersIgnoringModifiers:cs isARepeat:NO keyCode:c];
        NSEvent *eventUp = [NSEvent keyEventWithType:NSKeyUp location:pw modifierFlags:0 /*NSEventModifierFlags*/ timestamp:[NSDate timeIntervalSinceReferenceDate]+0.002 windowNumber:wnum context:[NSGraphicsContext currentContext] characters:cs charactersIgnoringModifiers:cs isARepeat:NO keyCode:c];
        if ((1)) {
            [NSApp postEvent:eventDn atStart:NO];
            [NSApp postEvent:eventUp atStart:NO];
        } else {
            [NSApp sendEvent:eventDn];
            [NSApp sendEvent:eventUp];
        }
        //[ctrl keyDown:eventDn];
        //[ctrl keyUp:eventUp];
        
    }
    [self consumeEvents];
}


@end

@implementation XCTestCaseGUIDoc

- (id) curDoc
{
    NSDocumentController *dctrl = [NSDocumentController sharedDocumentController];
    return [dctrl currentDocument];
}
- (void) closeAllDoc
{
    NSDocumentController *dctrl = [NSDocumentController sharedDocumentController];
    [dctrl closeAllDocumentsWithDelegate:self didCloseAllSelector:@selector(closedAll) contextInfo:NULL];
    [self resetMainWindow];
}

- (void) closedAll
{
    
}

- (NSDocument *) setupNewDoc
{
    [self resetMainWindow];
    [self waitAppActive];
    [self sleep:0.3];
    NSDocumentController *dctrl = [NSDocumentController sharedDocumentController];
    NSDocument *d1 = [dctrl currentDocument];
    [dctrl closeAllDocumentsWithDelegate:self didCloseAllSelector:@selector(closedAll) contextInfo:NULL];
    [self sleep:0.3];
    [dctrl newDocument:nil];
    [self resetMainWindow];
    NSDocument * __block d2;
    [self waitUntil:^() {
        d2 = [dctrl currentDocument];
        if (!d2) return NO;
        if (d2 == d1) return NO;
        NSLog(@"*** got new doc %@\n", d2);
        return YES;
    }];
    //[self waitAppActive];
    return d2;
}


@end

@implementation XCTestCaseGUINewDoc


- (void)setUp {
    [super setUp];
    NSDocument *d = [self setupNewDoc];
    NSLog(@"------ new doc %p\n", d);
    XCTAssert(d == [self curDoc]);
}

- (void)tearDown {
    [self closeAllDoc];
}

@end

@implementation XCTestCaseGUIdelegate


- (void)setUp {
    [super setUp];
    SEL m = [self setupMsg];
    XCTAssert(m);
    [[NSApp delegate] performSelector:m withObject:nil];
    NSDocument *d = [self curDoc];
    NSLog(@"------ new doc %p\n", d);
}

- (void)tearDown {
    [self closeAllDoc];
}

- (SEL) setupMsg
{
    return (SEL)0;
}

@end
