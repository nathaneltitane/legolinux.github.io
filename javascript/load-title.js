// load title //

$(function() {
	$.get("./title", function(data) {
		$("#title").append(data);
	});
});