// set random background //

$(document).ready(function() {
	var random_digit = Math.floor(Math.random() * 10);
	$('.background').css('background-image', 'url("/background/background-0' + random_digit + random_digit + '.png")');
});