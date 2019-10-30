$(document).ready(function() {
  jQuery.ajaxSettings.cache = true;

  if ($('.facebook-like-button').length > 0) {
    $('.facebook-like-button').html('<fb:like href="" send="true" layout="button_count" show_faces="true" font=""></fb:like>');

    if ($('#fb-root').length == 0) {
      $('body').append('<div id="fb-root"></div>');
      $('html').attr("xmlns:og","http://www.facebook.com/2008/fbml").attr("xmlns:fb","http://www.facebook.com/2008/fbml");
      $.getScript('//connect.facebook.net/en_US/all.js#appId=238642589492262&amp;xfbml=1', function(data, textStatus) {
        FB._https = (window.location.protocol == 'https:');
        FB.init({status: true, cookie: true, xfbml: true});
      });
    }
  }

  if ($('.twitter-tweet-button').length > 0) {
    $('.twitter-tweet-button').html('<a href="http://twitter.com/share" class="twitter-share-button" data-count="horizontal"></a>');
    $.getScript('//platform.twitter.com/widgets.js');
  }

  if ($('.google-plusone-button').length > 0) {    
    $('.google-plusone-button').html('<div class="g-plusone" data-size="medium"></div>');
    $.getScript('//apis.google.com/js/plusone.js');
  }  

  jQuery.ajaxSettings.cache = false;

});
