jQuery(document).ready(function(){
	// ROUNDED CORNERS FOR IE
	jQuery(function(){ 
		settings = {
			tl: { radius: 9 },
			tr: { radius: 9 },
			bl: { radius: 9 },
			br: { radius: 9 },
			autoPad: true,
			validTags: ["div"]
		}
		jQuery('#join-now').corner(settings);
		jQuery('#shumarks').corner(settings);
		jQuery('.style-one').corner(settings);
		jQuery('.style-two').corner(settings);
		jQuery('#profile .name').corner(settings);
		jQuery('tabs.ul li').corner(settings);
		jQuery('.tabs-container').corner(settings);
	});
	
	// FADE FOR BUTTONS
	jQuery(".fade").hover(
		function() {
			jQuery(this).animate({"opacity": "0.75"}, "fast");
		},
		function() {
			jQuery(this).animate({"opacity": "1"}, "fast");
	});
	
	// TAB STUFF
	//Default Action
	jQuery(".tab-content").hide(); //Hide all content
	jQuery("ul.tabs li:first").addClass("active").show(); //Activate first tab
	jQuery(".tab-content:first").show(); //Show first tab content
	
	//On Click Event
	jQuery("ul.tabs li").click(function() {
		jQuery("ul.tabs li").removeClass("active"); //Remove any "active" class
		jQuery(this).addClass("active"); //Add "active" class to selected tab
		jQuery(".tab-content").hide(); //Hide all tab content
		var activeTab = jQuery(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
		jQuery(activeTab).fadeIn(); //Fade in the active content
		return false;
	});	
	
	
});