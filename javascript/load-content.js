// load content //

function get_page_data(href) {
	$.get(href, parse_data);
}

function parse_data(data) {
	$('#load-content').empty();
	$('#load-content').append(data);
}
$(document).ready(function() {
	$('[data-link]').click(function(e) {
		e.preventDefault();
		var link = $(this).data('link');
		$('#load-content').fadeOut('slow');
		get_page_data(link);
		$('#load-content').fadeIn('slow');
		$('#loader').removeClass('no-padding');
		$('#loader').addClass('loader-open');
		$('html,body').animate({
				scrollTop: $('#navigation-bottom').offset().top
			},
			'slow');
		$('#anchors.hidden').show();
	});
});