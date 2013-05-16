(function() {

console.info("Loaded renderRuntime.js");

function loaded() {
	$(".link").click(tapToNavigate);
	$(".scroll").each(function() {
		myScroll = new iScroll(this,{ hideScrollbar:true });
	});
}

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);

document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);

document.addEventListener("refreshTemplate", loaded);

function tapToNavigate() {
	calliOSFunction("navigateTo", this.dataset.article_id);
}

}) ();

