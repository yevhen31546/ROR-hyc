$(document).ready(function() {
  $('a[rel=gallery]').fancybox({
    'hideOnContentClick': true,
    'transitionIn'      : 'elastic',
    'transitionOut'     : 'elastic',
    'titlePosition'     : 'inside',
    'changeSpeed'       : 75,
    'changeFade'        : 0,
    'titleFormat'       : function(title, currentArray, currentIndex, currentOpts) {
  	  return '<span id="fancybox-title-inside">Image ' + (currentIndex + 1) + ' / ' + currentArray.length + (title.length ? ' <br/> ' + title.replace(/\n/g, '<br/>') : '') + '</span>';
  	}
  });
});
