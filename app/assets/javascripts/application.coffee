window.fix_heights = ->
  hp_minor_padding = $("#hp_minor_sidebar").height() - $("#hp_minor_sidebar").innerHeight() + 44
  hp_main_padding = $("#hp_main_column").height() - $("#hp_main_column").innerHeight()

  if $("#hp_major_sidebar") < $("#hp_main_column")
    $("#hp_major_sidebar").css("height", $("#hp_main_column").height())
  else
    $("#hp_main_column").css("height", $("#hp_major_sidebar").height() + hp_main_padding)
    $("#hp_minor_sidebar").css("height", $("#hp_main_column").height() + hp_minor_padding)


highlight_search_results = ->
  matches_for_current_page = document.location.search.match(/[?&#038;](query|q)=([^&#038;]*)/)
  return if matches_for_current_page
  return unless document.referrer
  matches = document.referrer.match(/[?&#038;](query|q)=([^&#038;]*)/)
  return unless matches
  terms = unescape(matches[2].replace(/\+/g, " "))
  re = new RegExp().compile("(" + terms + ")", "i")
  $("body #main-content-inner *").each ->
    return if $(this).children().size() > 0
    return if $(this).is("xmp, pre")
    html = $(this).html()
    newhtml = html.replace(re, "<span class=\"qterm\">$1</span>")
    $(this).html newhtml

$(document).ready ->
  $("ul.sf-menu").superfish() unless typeof ($().superfish) == "undefined"
  $('input[placeholder],textarea[placeholder]').watermark() unless typeof($().watermark) == "undefined"
  if $("#twitter-link").length > 0
    $(".tweet").tweet
      join_text: "<br />"
      username: $("#twitter-link").attr("href").replace(/^http:\/\/twitter\.com\//, "")
      avatar_size: null
      count: 2
      loading_text: "loading tweets..."
  if $("#billy-scroller").length > 0
    $("ul#billy-indicators").empty()
    $("#billy-scroller").billy
      autoAnimate: false
      transition: 'fade'
      slidePause: 4000
      nextLink: $("#billy-next")
      prevLink: $("#billy-prev")
      indicators: $("ul#billy-indicators")

  if $("#info_tabs").length > 0
    $('#info_tabs').find('a').click ->
      target_id = $(this).attr('href')
      $(this).parent().parent().find('a').removeClass('active')
      $(this).addClass('active')
      $(target_id).siblings('.tab').hide()
      $(target_id).show()
      false


  if $('input.ui-datepicker').length > 0
    $('.ui-datepicker').datepicker({dateFormat: 'dd/M/yy'})

  # spam check
  if $('input.human_check').length > 0
    $('input.human_check').val('yes')

  highlight_search_results()

  if $('a#webcam_button').length > 0
    $('a#webcam_button').fancybox({
      'height': 560
      })

  if $('.trophy-winners').length > 0
    updateTrophyEvents = ->
      year = $('#year').val()
      event_type = $('input[name=event_type]:checked').val()
      url = '/trophy_winners/options?year='+year+'&event_type='+event_type
      $('#trophy_event_id').load(url)

    $('#year, input[name=event_type]').change(updateTrophyEvents)

  ## captions
  if captioned_images = $('img.captioned,img.caption,#main-content-inner img.caption[alt]')
    captioned_images.each (i, img) ->
      if $(img).attr('alt').length > 0
        $(img).wrap('<div class="captioned" style="width: '+ $(img).css('width') + '"></div>')
        $(img).removeClass('captioned caption')

        # move these properties from the image el to the wrapper el
        css_properties = ['float', 'margin-left', 'margin-right', 'margin-top', 'margin-bottom']
        for property in css_properties
          img_css_value = $(img).css(property)
          if (img_css_value)
            $(img).parent().css(property, img_css_value)
            if (property == 'float')
              $(img).css(property, 'none')
            else
              $(img).css(property, '0')
        $(img).parent().append("<div class='caption'>" + $(img).attr('alt') + "</div>")

  ## highlight selected event on open events page
  if document.location.hash
    event_rows = $(document.location.hash.replace(/#/, '.'))
  highlight_open_event = ($('body#body-events-index').length > 0 and
      event_rows and
      event_rows.length > 0
  )
  if highlight_open_event
    $(event_rows).addClass('highlighted-open-event')

  ## Crew finder behaviour
  if ($('.js-crew-finder-change-ad-type').length > 0)
    displayCorrectAdTypeFields = ->
      ad_type = $('.js-crew-finder-change-ad-type').val();
      if ad_type == 'available'
        $('.js-crew-finder-available').show();
        $('.js-crew-finder-wanted').hide();
      else
        $('.js-crew-finder-available').hide();
        $('.js-crew-finder-wanted').show();

    $('.js-crew-finder-change-ad-type').change ->
      displayCorrectAdTypeFields()
    displayCorrectAdTypeFields()


  # result_fields = [
  #                   [ "year", $("#result_year"), "Year" ],
  #                   [ "event_type", $("#result_event_type"), "Event type" ],
  #                   [ "event", $("#result_event"), "Event" ],
  #                   [ "class_name", $("#result_class"), "Class" ],
  #                 ]

  # $("#results_form").submit =>
  #   params = {}
  #   for i in [0..3]
  #     params[ result_fields[i][0] ] = result_fields[i][1].val()
  #     if result_fields[i][1].val() == ""
  #       result_fields[i][1].css("border", "2px solid red")
  #       return false

  #   $.get '/results/show', params, (data) =>
  #     console.debug(data)
  #     window.open(data, "_blank");
  #     window.focus();

  #   return false

  # for i in [0..2]
  #   result_fields[i][1].change ->
  #     if $(this).val() == ""

  #       return false

  #     $(this).css("border", "1px solid #bbb")

  #     i = 0
  #     for k in result_fields
  #       if k[1][0].id == this.id
  #         break
  #       i += 1

  #     return if i > 2

  #     for k in [i..2]
  #       result_fields[k+1][1].html('<option value="">' + result_fields[k+1][2] + '</option>');

  #     params = {}
  #     for j in [0..i]
  #       params[ result_fields[j][0] ] = result_fields[j][1].val()

  #     $.getJSON '/results/' + result_fields[i+1][0], params, (data) =>
  #         html = '<option value="">' + result_fields[i+1][2] + '</option>'
  #         for value in data
  #           console.debug(value)
  #           html += '<option value="' + value[result_fields[i+1][0]] + '">' + value[result_fields[i+1][0]] + '</option>';
  #         result_fields[i+1][1].html(html);

  #   if i > 0
  #     result_fields[i][1].html('<option value="">' + result_fields[i][2] + '</option>');
