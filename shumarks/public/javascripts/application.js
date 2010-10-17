// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.cookie = 'tz' + '=' + new Date().getTimezoneOffset() + '; path=/'; 

$(document).ready(function() {
	addInputDefaultValue($('#top-right-bar #session_login'), 'username');
	addInputDefaultValue($('#top-right-bar #session_password'), 'password');
});

function addInputDefaultValue(input, default_value) {
	input.blur(function() {
		if ($(this).val() == '') {
			$(this).val(default_value);
		}
	}).focus(function() {
		if ($(this).val() == default_value) {
			$(this).val('')
		}
	});
	input.val(default_value);
}

function showRemoveLink(index) {
	$('#delete-link-' + index).show()
}

function hideRemoveLink(index) {
	$('#delete-link-' + index).hide()
}

