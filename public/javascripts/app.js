console.log("filibuster")

$(document).keydown(function(e) {
    switch(e.which) {
        case 37: // left
        console.log("left");
        break;

        // case 38: // up
        // console.log("up");
        // break;

        case 39: // right
        console.log("right");
        break;

        // case 40: // down
        // console.log("down");
        // break;
        default: return; // exit this handler for other keys
    }
    e.preventDefault(); // prevent the default action (scroll / move caret)
});