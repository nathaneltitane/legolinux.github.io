// smooth scrolling link //

$('a').click(function() {
	$('html, body').animate({
		scrollTop: $($.attr(this, 'href')).offset().top
	}, 'slow');
	return false;
});