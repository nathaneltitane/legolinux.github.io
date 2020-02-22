// set random logo //

$(document).ready(function() {
	var logo_array = [
		['logo-01'],
		['logo-02'],
		['logo-03'],
		['logo-04'],
		['logo-05']
	];
	var index = Math.floor(Math.random() * logo_array.length);
	$('.logo').css('background-image', 'url("/logo/' + logo_array[index] + '.svg")');
});