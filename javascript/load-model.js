// load model //

$(function() {
	$('a.load-model').click(function(e) {
		e.preventDefault();
		$container = $('.load-here');
		$container_after = $('.load-here:after');
		$container.load([this.href, this.hash].join(' '), function() {
			$container.hide().removeClass('hidden').fadeIn('slow');
			$container.css({
				'padding': '20px 10px',
				'width': '100%'
			});
			$reveal = $('.container.hidden').filter(':first');
			$reveal.fadeIn('slow').removeClass('hidden');
			$('html,body').animate({
					scrollTop: $('#navigation-bottom').offset().top
				},
				'slow');
		});
	});
});