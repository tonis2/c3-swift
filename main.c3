
struct Params {
    int depth;
    int x;
    int y;
    int width;
    int height;
    int border_width;
}

extern fn int createWindow(Params params, String name) @extern("createWindow");
extern fn int testWindow(Params params) @extern("testWindow");

fn void! main(String[] args)
{
    createWindow(
        params: {
            .width = 900,
            .height = 600,
            .x = 0,
            .y = 0
        },
        name: "Test window"
    );
    // int value = testFn(
    //     params: {
    //         .width = 900,
    //         .height = 600,
    //         .x = 0,
    //         .y = 0
    //     },
    // );
}