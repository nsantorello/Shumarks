$(document).ready(function(){
	// ROUNDED CORNERS FOR IE
	$(function(){ 
		settings = {
			tl: { radius: 9 },
			tr: { radius: 9 },
			bl: { radius: 9 },
			br: { radius: 9 },
			autoPad: true,
			validTags: ["div"]
		}
		$('#join-now').corner(settings);
		$('#shumarks').corner(settings);
		$('.style-one').corner(settings);
		$('.style-two').corner(settings);
		$('#profile .name').corner(settings);
		$('tabs.ul li').corner(settings);
		$('.tabs-container').corner(settings);
	});
	
	// FADE FOR BUTTONS
	$(".fade").hover(
		function() {
			$(this).animate({"opacity": "0.75"}, "fast");
		},
		function() {
			$(this).animate({"opacity": "1"}, "fast");
	});
	
	// TAB STUFF
	//Default Action
	$(".tab-content").hide(); //Hide all content
	$("ul.tabs li:first").addClass("active").show(); //Activate first tab
	$(".tab-content:first").show(); //Show first tab content
	
	//On Click Event
	$("ul.tabs li").click(function() {
		$("ul.tabs li").removeClass("active"); //Remove any "active" class
		$(this).addClass("active"); //Add "active" class to selected tab
		$(".tab-content").hide(); //Hide all tab content
		var activeTab = $(this).find("a").attr("href"); //Find the rel attribute value to identify the active tab + content
		$(activeTab).fadeIn(); //Fade in the active content
		return false;
	});	
	
	
});