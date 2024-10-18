import Cocoa

@objc public class Params: NSObject {
    var depth: Int = 0
    var x: Int = 0
    var y: Int = 0
    var width: Int = 0
    var height: Int = 0
    var border_width: Int = 0
}

@objc class CustomWindow: NSObject {
    let window: NSWindow!
    let controller: NSWindowController;

    init(window: NSWindow, controller: NSWindowController) {
        self.window = window
        self.controller = controller;
    }
}

@_cdecl("createWindow")
func createWindow(params: Params, title: String) -> CustomWindow {
    let window: NSWindow;
    let mask: NSWindow.StyleMask = [.closable, .titled, .resizable, .miniaturizable];
    window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: params.width, height: params.height), styleMask: mask, backing: .buffered, defer: true)
    window.title = title
    window.makeKeyAndOrderFront(nil)

    let controller = NSWindowController(window: window)

    return CustomWindow (window: window, controller: controller);
}

@_cdecl("testFn")
public func testFn(params: Params) -> Int {
    return 5;
}

