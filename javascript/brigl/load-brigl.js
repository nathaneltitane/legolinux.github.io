// load brigl //

$(document).ready(
	function() {
		$(".ldraw-container").each(
			function(index, container) {
				console.log(index, container);
				if (!Detector.webgl) {
					alert("No support for WebGL detected!");
					return;
				}
				//  capture and show log
				BRIGL.log = function(msg) {
					document.getElementById("message_log").textContent = msg;
				};

				// Usage:

				// BRIGL.Builder options usage: var builder = new BRIGL.Builder("parts/", {option:"value"});

				// Options:

				// forceLowercase: forces partname to lowercase when downloading from server. 					Default: false
				// dontUseSubfolders: as explained above, avoid using subfolders for parts.						Default: false
				// ajaxMethod: choose which library to use for ajax calls. Values: "jquery", "prototype". 		Default: "prototype"
				// loadModelByName Options - also valid for other loadModelBy...();
				// drawLines: draw edge lines.																	Default: false
				// blackLines: draw all edge lines in black														Default: false
				// dontCenter: don't calculate center of object, use model origin instead. 						Default: false
				// dontSmooth: avoid smoothing process.															Default: false
				// startingMatrix: use value as the starting transformation matrix.								Default: undefined
				// centerOffset: use this vector as the center offset (the displacement of the model).			Default: undefined
				// stepLimit: read a model only up to 'stepLimit' number of steps. (Ex.:show partial build)		Default: -1 (No limit)
				// startColor: use value as starting color.														Default: 16
				// create builder object to obtain models

				var builder = new BRIGL.Builder(
					"/ldraw/parts/", {
						ajaxMethod: "jquery",
						dontUseSubfolders: true,
					}
				);
				var button = $(container).find(".ldraw-button");
				var model_url = $(container).attr("model_url");
				button.click(
					function(event) {
						var $width = $('.ldraw-container').width();
						var $height = $('.ldraw-container').height();
						$(container).empty();
						$('.ldraw .canvas').css(
							{
								'width': $width,
								'height': $height
							}
						);
						builder.loadModelByUrl(
							model_url, {
								drawLines: true
							},
							function(threejsMesh) {
								// show model in container after parsing
								// new BRIGL.BriglContainer(document.getElementById("ldraw-container"), threejsMesh).render();
								var viewer = new BRIGL.BriglContainer(container, threejsMesh);
								viewer.render();
							}
						);
					}
				);
			}
		);
	}
);