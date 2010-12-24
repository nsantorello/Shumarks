// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
document.cookie = 'tz' + '=' + new Date().getTimezoneOffset() + '; path=/'; 

jQuery(document).ready(function() {
	addInputDefaultValue(jQuery('#top-right-bar #session_login'), 'username');
	addInputDefaultValue(jQuery('#top-right-bar #session_password'), 'password');
});

function addInputDefaultValue(input, default_value) {
  if (input.length > 0) {
  	input.blur(function() {
  		if (jQuery(this).val() == '') {
  			jQuery(this).val(default_value);
  		}
  	}).focus(function() {
  		if (jQuery(this).val() == default_value) {
  			jQuery(this).val('')
  		}
  	});
  	input.val(default_value);
  }
}

function showRemoveLink(index) {
	jQuery('#delete-link-' + index).show()
}

function hideRemoveLink(index) {
	jQuery('#delete-link-' + index).hide()
}

