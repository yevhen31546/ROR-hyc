jQuery(document).ready(function() {
	// Ajax calendar
	jQuery('table.calendar a.monthLink').live('click', function(e){
		e.preventDefault();
		var event_path = jQuery(this).attr('href'); 
		var month_param = event_path.match(/[&?]event_month=?([^&?]*)/)[1] || '';
		var calendar = jQuery(this).closest('.calendar');
		calendar.find('*').css('cursor', 'progress');

		jQuery.get('/events/calendar_ajax', {event_month: month_param},
			function(responseText){
				calendar.replaceWith(responseText);
				calendar.find('*').css('cursor', null);
			}, 'html'
		);

		return false;
	});
});
