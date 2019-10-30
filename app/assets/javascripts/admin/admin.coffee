jQuery(document).ready ->
  convertTitleToUrl = (title) ->
    "/" + convertTitleToCode(title)
  convertTitleToCode = (title) ->
    title.toLowerCase().replace(/^\W+/, "").replace(/\W+$/, "").replace /[\W\s]+/g, "-"
  jQuery("#announcements").load "/admin/dashboard/announcements_ajax"

  initDatePicker = () ->
    if jQuery("input.ui-datepicker").length > 0
      Date.format = "dd/mmm/yyyy"
      jQuery("input.ui-datepicker").datePicker
        startDate: "01/Jan/2000"
        endDate: "31/Dec/2099"
        flat: true
  initDatePicker()

  if jQuery('input.ui-datetimepicker').length > 0
    jQuery('.ui-datetimepicker').datetimepicker({dateFormat: 'dd/M/yy'})

  page_form = jQuery("#new_page.page, form.page")
  if page_form.length > 0
    page_form.find("#page_title").blur ->
      current_title = jQuery(this).val()
      page_url = page_form.find("#page_url")
      page_url.val convertTitleToUrl(current_title)  if page_url.val() == ""
      page_code = page_form.find("#page_code")
      page_code.val convertTitleToCode(current_title)  if page_code.val() == ""


  if $('#seo_options').length > 0
    $('#seo_options').find('ul').hide()
    $('#seo_options legend').click () ->
      $(this).parent().toggleClass('open')
      $(this).parent().find('ul').toggle()

  if $('#select_sponsor').length > 0
    $('#select_sponsor').fancybox({
      width: 650, height: 500
    });

  select_all = jQuery('#select_all')
  if select_all.length > 0
    select_all.click () ->
      check_boxes = jQuery(this).parents('table').find("input:checkbox")
      if jQuery(this).attr('checked')
        check_boxes.attr('checked', 'checked')
      else
        check_boxes.removeAttr('checked')

  if $('#new_field').length > 0
    $('#new_field').click () ->
      size = $('#new_field').parent().parent().find('ul.form_field').length
      $.get "/admin/form_templates/new_form_field", {i: size}, (data) ->
        $('#new_field').parent().before($(data).find('ul.form_field'))
      false

  if $('#new_charge').length > 0
    $(document).on 'click', '#new_charge', () ->
      size = $('#new_charge').parent().parent().find('ul.charge').length
      $.get "/admin/entry_forms/new_charge", {i: size}, (data) ->
        $('#new_charge').parent().before($(data).find('ul.charge'))
        initDatePicker()
      false

  if $('#new_category').length > 0
    $(document).on 'click', '#new_category', () ->
      size = $('#new_category').parent().parent().find('ul.category').length
      $.get "/admin/entry_forms/new_category", {i: size}, (data) ->
        $('#new_category').parent().before($(data).find('ul.category'))
      false

  if $('#new_date').length > 0
    $('#new_date').click () ->
      size = $('#new_date').parent().parent().find('li.date').length
      $.get "/admin/events/new_date", {i: size}, (data) ->
        $('#new_date').parent().before($(data).find('ul li.date'))
        initDatePicker()
      false

  if $('.js-add-new-event-logo').length > 0
    $('.js-add-new-event-logo').click (e) ->
      e.preventDefault();
      size = $('.js-add-new-event-logo').parent().parent().find('ul.event_logo').length
      $.get "/admin/events/new_event_logo", {i: size}, (data) ->
        console.log(data);
        $('.js-add-new-event-logo').parent().before($(data).find('ul.event_logo'))
      false

  if $('form.event_resource').length > 0
    resource_type_select = $('select#event_resource_resource_type')
    changeResourceType = ->
      console.log('change')
      resource_type = resource_type_select.val()
      form = resource_type_select.closest('form')
      form.find('ul.resource_type').hide().find('input').attr('disabled', true)
      form.find('ul#resource_'+resource_type).show().find('input').removeAttr('disabled')

    resource_type_select.change changeResourceType
    changeResourceType()

  if $('#pre_resources.sortable_table').length > 0
    $('#pre_resources.sortable_table').sortable
      handle: '.handle',
      axis: 'y',
      items: 'tr.resource'
      update: (e, ui) ->
        resource_tr = $(ui.item)
        resource_table = resource_tr.parent()
        resource_trs = resource_table.children('tr.resource')
        ids = resource_trs.map (i, resource_el) ->
          parseInt($(resource_el).data('id'))
        $.post "/admin/event_resources/update_positions", {"ids[]": ids.toArray()}

  if $('#post_resources.sortable_table').length > 0
    $('#post_resources.sortable_table').sortable
      handle: '.handle',
      axis: 'y',
      items: 'tr.resource'
      update: (e, ui) ->
        resource_tr = $(ui.item)
        resource_table = resource_tr.parent()
        resource_trs = resource_table.children('tr.resource')
        ids = resource_trs.map (i, resource_el) ->
          parseInt($(resource_el).data('id'))
        $.post "/admin/event_resources/update_positions", {"ids[]": ids.toArray()}


  if $('#contacts.sortable_table').length > 0
    $('#contacts.sortable_table').sortable
      handle: '.handle',
      axis: 'y',
      items: 'tr.contact'
      update: (e, ui) ->
        resource_tr = $(ui.item)
        resource_table = resource_tr.parent()
        resource_trs = resource_table.children('tr.contact')
        ids = resource_trs.map (i, resource_el) ->
          parseInt($(resource_el).data('id'))
        $.post "/admin/contacts/update_positions", {"ids[]": ids.toArray()}

  if $('#sortable_charges').length > 0
    $('#sortable_charges').sortable
      handle: '.handle',
      axis: 'y',
      items: '.charge'
      update: (e, ui) ->
        charge_el = $(ui.item)
        charge_wrapper = charge_el.parent()
        charge_els = charge_wrapper.children('.charge')
        ids = charge_els.map (i, el) ->
          parseInt($(el).data('id'))
        $.post "/admin/entry_forms/update_charge_positions", {"ids[]": ids.toArray()}


  if $('#sortable_categories').length > 0
    $('#sortable_categories').sortable
      handle: '.handle',
      axis: 'y',
      items: '.category'
      update: (e, ui) ->
        category_el = $(ui.item)
        category_wrapper = category_el.parent()
        category_els = category_wrapper.children('.category')
        ids = category_els.map (i, el) ->
          parseInt($(el).data('id'))
        $.post "/admin/entry_forms/update_category_positions", {"ids[]": ids.toArray()}


  $('#event_year_filter').change ->
    year = $(this).val()
    event_select = $(this).next('select')
    with_forms = $(this).data('with-forms')
    console.log(with_forms)
    with_forms = (if typeof(with_forms) == 'undefined' then '' else with_forms)
    console.log(with_forms)
    console.log('/admin/events/options?year='+year+'&with_forms='+with_forms)
    event_select.load('/admin/events/options?year='+year+'&with_forms='+with_forms)


  $('#entry_list_event_filter').change ->
    event_id = $(this).val()
    event_select = $(this).next('select')
    event_select.load('/admin/entry_lists/options_for_event?event_id='+event_id)

  if $('#results_finder').length > 0
    loadEvents = () ->
      year = $('#event_year_filter_alt').val()
      event_type = $('#event_type_filter').val()
      event_select = $('#results_finder').find('select#event_id')
      event_select.load('/admin/events/options?year='+year+'&event_type='+event_type)

    $('#results_finder').find('#event_type_filter, #event_year_filter_alt').change(loadEvents)

  updateTrophyEvents = ->
    year = $('#trophy_event_year_filter').val()
    event_type = $('#trophy_event_type_filter').val()
    url = '/admin/trophy_events/options?year='+year+'&event_type='+event_type
    $('#trophy_event_filter').load(url)

  $('#trophy_event_year_filter').change(updateTrophyEvents)
  $('#trophy_event_type_filter').change(updateTrophyEvents)

  $('#event_dinner_year_filter').change ->
    year = $(this).val()
    event_select = $(this).next('select')
    event_select.load('/admin/event_dinners/options?year='+year)

