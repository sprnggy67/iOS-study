/**
 * A set of functions which add runtime behaviour where necessary to the article renderer output
 */

var ds = ds || {};

ds.addRuntime = function() {
	ds.addRuntimeInteraction();
	ds.addRuntimeStyles();
}

ds.addRuntimeInteraction = function() {
	$(".link").click(ds.tapToNavigate);

	$(".scroll").each(function() {
		myScroll = new iScroll(this,{ hideScrollbar:true, hscroll:false,
		    onBeforeScrollStart: function ( e ) {
		        if ( this.absDistY > (this.absDistX + 5 ) ) {
		            // user is scrolling the y axis, so prevent the browsers' native scrolling
		            e.preventDefault();
		        }
		    }
		});
	});

	//document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
}

ds.addRuntimeStyles = function() {
	$(".gridData>img").each(function() {
		// Get the aspect ratio of the div
		var parentDiv = this.parentNode;
		var refW = $(parentDiv).width();
		var refH = $(parentDiv).height();
		var refRatio = refW/refH;

		// Get the aspect ratio of the image
		var imgW = $(this).width();
		var imgH = $(this).height();
		var imgRatio = imgW/imgH;

		// Calculate the fill.
		if ( imgRatio < refRatio ) { 
			$(this).addClass("fillWidth");
			var scalingFactor = refW / imgW;
			var marginTop = - (imgH * scalingFactor - refH) / 2;
			$(this).css('margin-top', marginTop +'px');
		} else {
			$(this).addClass("fillHeight");
			var scalingFactor = refH / imgH;
			var marginLeft = - (imgW * scalingFactor - refW) / 2;
			$(this).css('margin-left', marginLeft +'px');
		}
	});
	$(".flow>img").each(function() {
		$(this).addClass("fillWidth");
	});
}

ds.tapToNavigate = function() {
	calliOSFunction("navigateTo", this.dataset.article_id);
}
