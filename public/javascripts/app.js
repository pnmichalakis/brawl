$(document).ready(function(){
  $(document).keydown(function(e) {
    switch(e.which) {
        case 37: // left
        console.log("left");
        $('#dislike').submit();
        break;

        case 39: // right
        console.log("right");
        $('#like').submit();
        break;

        default: return;
    }
    e.preventDefault();
  });
$(".oppinfo").hide();
$(".toggle").click(function(){
  $(".oppinfo").slideToggle();
  });
$(".editprofileform").hide();
$("#editprofileshow").click(function(){
    $(".editprofileform").toggle();
    $(".standardprofileview").toggle();
  });
});


