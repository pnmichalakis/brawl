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
$("#like").submit(function(e){
  // e.preventDefault();
  // alert("liked");
  // console.log("like")
  // location.reload(true);
});
$("#dislike").submit(function(){
  // alert("disliked")
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
$(".likesubmit").hover(function(){
  $("#opponent").append( $( "<span class='likehover'> Fight!</span>" ) );
}, function(){
  $("#opponent").find("span:last").remove();
});
$(".dislikesubmit").hover(function(){
  $("#opponent").append( $( "<span class='dislikehover'> No Thanks</span>" ) );
}, function(){
  $("#opponent").find("span:last").remove();
});
});


