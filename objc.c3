import std::io, std::os::darwin::cocoa, std::os::macos::objc;

distinct WindowStyleMask = inline int;
const WindowStyleMask WINDOW_STYLE_MASK_BORDERLESS = 0;
const WindowStyleMask WINDOW_STYLE_MASK_TITLED = 1 << 0;
const WindowStyleMask WINDOW_STYLE_MASK_CLOSABLE = 1 << 1;
const WindowStyleMask WINDOW_STYLE_MASK_MINIMIZABLE = 1 << 2;
const WindowStyleMask WINDOW_STYLE_MASK_RESIZABLE = 1 << 3;
const WindowStyleMask WINDOW_STYLE_MASK_UNIFIED_TITLE_TOOLBAR = 1 << 12;
const WindowStyleMask WINDOW_STYLE_MASK_FULL_SCREEN = 1 << 14;
const WindowStyleMask WINDOW_STYLE_MASK_UTILITY_WINDOW = 1 << 4;
const WindowStyleMask WINDOW_STYLE_MASK_NON_ACTIVATING = 1 << 7;

distinct BackingStoreType = inline int;
const BackingStoreType BACKING_STORE_RETAINED = 0;
const BackingStoreType BACKING_STORE_NON_RETAINED = 1;
const BackingStoreType BACKING_STORE_BUFFERED = 2;

def NSApplication = void*;
def NSWindow = void*;
def AppWindow = void*;

def MsgSendEmpty = fn void*(void*, ObjcSelector);
def MsgSendId = fn void*(void*, ObjcSelector, uint);
def MsgSendPtr = fn void*(void*, ObjcSelector, void*);
def MsgCreateWindow = fn void*(void*, ObjcSelector, Rect, CInt, CInt, bool);

extern fn ObjcClass allocateClassPair(ObjcClass class, ZString name, int) @extern("objc_allocateClassPair");
extern fn bool class_addIvar(ObjcClass class, ZString name, int size, int alignment, ZString types) @extern("class_addIvar");
extern fn ObjcIvar set_instance_variable(ObjcId class, ZString selector, void* value) @extern("object_setInstanceVariable");

fn ObjcId alloc_class(ObjcClass class) => objc::msg_send(class, MsgSendEmpty, "alloc");

struct Rect {
    int x;
    int y;
    int width;
    int height;
}

fn void! main(String[] args)
{
    ObjcId poolAlloc = objc::msg_send(objc::class_by_name("NSAutoreleasePool")!!, MsgSendEmpty, "alloc");
    ObjcId pool = objc::msg_send(poolAlloc, MsgSendEmpty, "init");
    defer objc::msg_send(pool, MsgSendEmpty, "drain");

    int macArgs = WINDOW_STYLE_MASK_TITLED | WINDOW_STYLE_MASK_CLOSABLE | WINDOW_STYLE_MASK_MINIMIZABLE;

    NSApplication app = objc::msg_send(objc::class_by_name("NSApplication")!!, MsgSendEmpty, "sharedApplication");
    objc::msg_send(app, MsgSendId, "setActivationPolicy:", 0);

    NSWindow window = objc::msg_send(
                                    alloc_class(objc::class_by_name("NSWindow")!!), 
                                    MsgCreateWindow, 
                                    "initWithContentRect:styleMask:backing:defer:",
                                    Rect {0, 0, 500, 500},
                                    macArgs,
                                    BACKING_STORE_BUFFERED,
                                    false
                                    );

    defer objc::msg_send(window, MsgSendEmpty, "autorelease");
    if (window == null) {
        io::printfn("Failed to create window");
        return;
    };

    ObjcClass delegateClass = allocateClassPair(objc::class_by_name("NSObject")!!, "WindowDelegate", 0);
    class_addIvar(delegateClass, "RGFW_window", AppWindow.sizeof, AppWindow.sizeof * 4, "L");

    ObjcId delegate = objc::msg_send(alloc_class(delegateClass), MsgSendEmpty, "init");
    defer objc::msg_send(delegate, MsgSendEmpty, "autorelease");
    set_instance_variable(delegate, "NSWindow", window);

    objc::msg_send(window, MsgSendPtr, "setDelegate:", delegate);
    objc::msg_send(window, MsgSendId, "setIsVisible:", 1);
    objc::msg_send(window, MsgSendPtr, "makeKeyAndOrderFront:", null);
    objc::msg_send(app, MsgSendId, "activateIgnoringOtherApps:", 1);
    objc::msg_send(app, MsgSendEmpty, "finishLaunching");

    bool running = true;                  
    while (running) {

    }
}