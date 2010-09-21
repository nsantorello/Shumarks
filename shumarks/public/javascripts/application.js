// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.cookie = 'tz' + '=' + new Date().getTimezoneOffset() + '; path=/'; 


function showRemoveLink(index) {
	$('#delete-link-' + index).show()
}

function hideRemoveLink(index) {
	$('#delete-link-' + index).hide()
}

