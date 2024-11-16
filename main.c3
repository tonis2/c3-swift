import std::io, std::os::darwin::cocoa;
import window;

fn void! main(String[] args)
{
    window::createWindow(Rect {300, 300, 800, 500});
}