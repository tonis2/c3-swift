import std::io, std::os::darwin::cocoa;

struct Rect {
    int x;
    int y;
    int width;
    int height;
}

extern fn void createWindow(Rect rect) @extern("create_window");

fn void! main(String[] args)
{
    createWindow(Rect {300, 300, 800, 500});
}