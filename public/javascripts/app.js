console.log("filibuster")

$(document).ready(function(){
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
        // break;
        default: return; // exit this handler for other keys
    }
    e.preventDefault(); // prevent the default action (scroll / move caret)
});
});

// $(document).ready(function() { 
//  // bind 'myForm' and provide a simple callback function 
//    $('#like').ajaxForm(function() { 
//      alert("Liked!"); 
//     });
//    $('#dislike').ajaxForm(function() { 
//      alert("disliked!"); 
//     });  
//   });
