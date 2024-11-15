#import <Cocoa/Cocoa.h>

void create_window() {
    @autoreleasepool {
        // Create a default window
        NSWindow *window = [[NSWindow alloc] init];
        // Make it blue just for better visibility
        [window setBackgroundColor:[NSColor blueColor]];
        [window setFrame:NSMakeRect(500.0f, 500.0f, 800.0f, 400.f) display:YES animate:YES];
        // Bring to front and make it key
        [window makeKeyAndOrderFront:nil];
        // Custom run loop
        NSEvent* event;
        while(1) {
            do {
                event = [window nextEventMatchingMask:NSEventMaskAny]; //window shows now
                if ([event type] == NSEventTypeLeftMouseDown) {
                    NSLog(@"Mouse down");
                }
                else {
                    NSLog(@"Something happened");
                }
            } while (event != nil);
        }
    }
}