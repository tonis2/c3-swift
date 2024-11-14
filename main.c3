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
def Id = void*;
def MsgSendEmpty = fn void*(void*, ObjcSelector);
def MsgSendId = fn void*(void*, ObjcSelector, uint);
def MsgCreateWindow = fn void*(void*, ObjcSelector, Rect, CInt, CInt, bool);

struct Rect {
    CInt x;
    CInt y;
    CInt width;
    CInt height;
}

fn void! main(String[] args)
{
    Id poolAlloc = objc::msg_send(objc::class_by_name("NSAutoreleasePool")!!, MsgSendEmpty, "alloc");
    Id pool = objc::msg_send(poolAlloc, MsgSendEmpty, "init");
    defer objc::msg_send(pool, MsgSendEmpty, "drain");

    int macArgs = WINDOW_STYLE_MASK_TITLED | WINDOW_STYLE_MASK_CLOSABLE | WINDOW_STYLE_MASK_MINIMIZABLE;

    NSApplication ptr = objc::msg_send(objc::class_by_name("NSApplication")!!, MsgSendEmpty, "sharedApplication");
    objc::msg_send(ptr, MsgSendId, "setActivationPolicy:", 0);
    Id window_alloc = objc::msg_send(objc::class_by_name("NSWindow")!!, MsgSendEmpty, "alloc");

    NSWindow window = objc::msg_send(
                                    window_alloc, 
                                    MsgCreateWindow, 
                                    "initWithContentRect:styleMask:backing:defer:",
                                    Rect {200, 200, 200, 200},
                                    macArgs,
                                    BACKING_STORE_BUFFERED,
                                    false
                                    );

    defer objc::msg_send(window, MsgSendEmpty, "autorelease");
    if (window == null) io::printfn("%d", window);

    // Todo objc_allocateClassPair                         

}