//= require head
//= require jquery
//= require moxie
//= require plupload.dev
//= require plupload.settings
//= require jquery.plupload.queue

//= require events
//= require ../../fancybox/jquery.easing.1.3
//= require ../../fancybox/jquery.mousewheel-3.0.4
//= require ../../fancybox/jquery.fancybox-1.3.4

jQuery(document).ready ->
  $('a.use').click ->
    asset_id = $(this).data('id')
    parent.$('#event_sponsor_logo_id').val(asset_id)
    parent.$('#sponsor_thumbnail').load("/admin/assets/#{asset_id}/thumbnail")
    parent.$.fancybox.close()
    return false

  $('a.use_multiple').click ->
    resource_ids = []
    $('#assets_wrapper input[type=checkbox]:checked').each (key, value) ->
      resource_ids.push($(value).val())
    parent.addResources(resource_ids)
    parent.$.fancybox.close()
    return false

