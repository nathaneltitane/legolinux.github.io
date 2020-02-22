// force to top before refresh //

$(window).on('beforeunload', function() {
	$(document).scrollTop(0);
});