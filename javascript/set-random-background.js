// set random background //

$(document).ready(function() {
var count = 116;

function pad(str, max) {
str = str.toString();
return str.length < max ? pad("0" + str, max) : str;
}

$('.background').css(
'background-image',
'url("/background/background-' + pad(Math.floor(Math.random() * count), 3) + '.png ")'
);
});
