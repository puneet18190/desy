function initTagsAutocomplete(div_id){
  function split( val ) {
    return val.split( /,\s*/ );
  }
  function extractLast( term ) {
    $(".ui-autocomplete").css("left",0);
    $(".ui-autocomplete").css("top",($("#tags").position().top+20)+"px");
    return split( term ).pop();
  }
  
  
  $(function(){
		
		//attach autocomplete
		$("#"+div_id).autocomplete({
			
			//define callback to format results
			source: function( request, response ) {
        $.getJSON( "/lessons_editor/get_tag_list", {
          term: extractLast( request.term )
        }, response );
      },
      search: function() {
        // custom minLength
        var term = extractLast( this.value );
        if ( term.length < 2 ) {
          return false;
        }
      },
						
			//define select handler
			select: function(e, ui) {
				
				//create formatted friend
				var friend = ui.item.value,
					span = $("<span>").text(friend),
					a = $("<a>").addClass("remove").attr({
						href: "javascript:",
						title: "Remove " + friend
					}).text("x").appendTo(span);
				
				//add friend to friend div
				console.log($("#"+div_id).val())
				span.insertBefore("#"+div_id);
				$("#"+div_id).val("").css("top", 2);
			},
			
			//define select handler
			change: function() {
				
				//prevent 'to' field being updated and correct position
				$("#"+div_id).val("").css("top", 2);
			}
		});
		
		//add click handler to new-lesson-tags div
		$("#new-lesson-tags").click(function(){
			
			//focus 'to' field
			$("#"+div_id).focus();
		});
		
		//add live handler for clicks on remove links
		$(".remove", document.getElementById("new-lesson-tags")).live("click", function(){
		
			//remove current friend
			$(this).parent().remove();
			
			//correct 'to' field position
			if($("#new-lesson-tags span").length === 0) {
				$("#"+div_id).css("top", 0);
			}				
		});				
	});
}