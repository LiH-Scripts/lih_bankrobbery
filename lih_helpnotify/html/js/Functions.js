window.addEventListener('message', function(event) {    
    if (event.data.action == "showHelpNotification") {
	  var keyPressText = document.querySelector('.KeyPress-Text');
	  keyPressText.innerHTML = event.data.text.toUpperCase();;
        $(".Main").show()
    }
    if (event.data.action == "hideHelpNotification") {
        $(".Main").hide()
    }
})