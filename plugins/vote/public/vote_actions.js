var openEvent = null;
jQuery( document ).ready(function( $ ) {
  $(".vote-action").live('mouseenter', function() {
    var div = $(this);
    if(openEvent==null)
      openEvent = setInterval(function() { openVotersDialog(div); }, 500);
  });
  $(".vote-action").live('mouseleave', function() {
    clearTimeout(openEvent);
    openEvent = null;
  });
});

function openVotersDialog(div) {
  var $ = jQuery;
  clearTimeout(openEvent);
  var url = $(div).data('reload_url');
  hideAllVoteDetail();
  if(url && url != '#'){
    $.ajax({ type : "POST", url: url, dataType : "script" })
  }
}

jQuery('body').live('click', function() { hideAllVoteDetail(); });

function hideAllVoteDetail() {
  jQuery('.vote-detail').fadeOut('slow');
}
