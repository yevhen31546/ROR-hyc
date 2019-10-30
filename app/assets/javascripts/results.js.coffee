jQuery(document).ready ->
  if $('#results_frontend').length > 0
    loadUniqueResultEventTitles = () ->
      year = $('#event_year_filter_alt').val()
      event_type = $('#event_type_filter').val()
      event_select = $('#results_frontend').find('select#event_title')
      event_select.load('/results/event_options?year='+year+'&event_type='+event_type)

    $('#results_frontend').find('#event_type_filter, #event_year_filter_alt').change(loadUniqueResultEventTitles)

    loadResultClassNames = () ->
      event_title = $(this).val()
      year = $('#event_year_filter_alt').val()
      $('#result_class_name').load('/results/class_options?event_title='+encodeURIComponent(event_title)+'&year='+encodeURIComponent(year))

    $('#results_frontend').find('#event_title').change(loadResultClassNames)
