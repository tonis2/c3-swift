import std::io, std::os::darwin::cocoa;


extern fn void createWindow() @extern("create_window");

fn void! main(String[] args)
{
    createWindow();
}