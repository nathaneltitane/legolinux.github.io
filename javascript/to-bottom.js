// to bottom //

$(document).ready(function() {
	$('.to-bottom').click(function(event) {
		event.preventDefault();
		$('html, body').animate({
			scrollTop: $(document).height()
		}, 'slow');
		return false;
	});
});