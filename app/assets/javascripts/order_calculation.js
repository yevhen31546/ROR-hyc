$(document).ready(function () {
	$('.amount').change(function () {
		var amount = 0;
		$.each($('.amount'), function () {
			if ($(this).val().length != 0) {
				var value = Number($(this).val());

				if (!isNaN(value)) {
					amount += value;
				}
			}
		});
		$('#order_total').val(amount);
	});
});