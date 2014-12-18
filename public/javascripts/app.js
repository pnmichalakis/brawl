$(document).ready(function(){
  $(document).keydown(function(e) {
    switch(e.which) {
        case 37: // left
        console.log("left");
        $('#dislike').submit();
        break;

        // case 38: // up
        // console.log("up");
        // break;

        case 39: // right
        console.log("right");
        $('#like').submit();
        break;

        // case 40: // down
        // break;
        default: return;
    }
    e.preventDefault();
  });
$(".oppinfo").hide();
$(".toggle").click(function(){
  $(".oppinfo").slideToggle();
  });
});


