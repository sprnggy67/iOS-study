(function() {

function loaded() {
	$(".link").click(tapToNavigate);
    $(".scroll").each(function() {
        myScroll = new iScroll(this,{
            hideScrollbar:true,
            hscroll:false,
            onBeforeScrollStart: function ( e ) {
                if ( this.absDistY > (this.absDistX + 5 ) ) {
                    // user is scrolling the y axis, so prevent the browsers' native scrolling
                    e.preventDefault();
                }
            }
        });
    });
}

document.addEventListener('DOMContentLoaded', function () { setTimeout(loaded, 200); }, false);

document.addEventListener("refreshTemplate", loaded);

function tapToNavigate() {
	calliOSFunction("navigateTo", this.dataset.article_id);
}

}) ();

