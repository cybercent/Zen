$(function(){
	$("body").tooltip({selector: '[rel=tooltip]', placement:"bottom", delay:{show:500, hide:200}});
	
	// Clear new project form
	$("#new_project_modal").on('hide', function(){
		$(".modal form").attr("action","/projects");
		$(".modal form input").attr("value",'');
		$(".estimate").attr("class","estimate").removeAttr("data-value");
	});
	
	// Estimated value
	$(".estimate a").click(function(){
	  var estimation = $(this).attr('data-value');
	  $(".estimate").attr("class","estimate estimated_"+estimation).attr("data-value",estimation);
	  $("#project_exact_value").attr("value",'');
	});
	$(".estimate a").hover(
		function(){
		  $(this).prevUntil(".estimate a:first").addClass("hover");
		},
		function() {
		  $(".estimate a").removeClass("hover")
		}
	);
	$("#project_exact_value").focus(function(){$(".estimate").attr("class","estimate").removeAttr("data-value");});
	
	
	function update_sidebar_info(data) {
	  var info = $('<ul>'+data+'</ul>').find('.info');
	  if(typeof info != 'undefined') {
	    var free_projects = info.find('.free-deals');
	    var available_projects_count = info.find('.active-deals');
	    var available_projects_value = info.find('.deals-value');
	    $(".projects-count").html(available_projects_count);
	    $(".projects-value").html(available_projects_value);
	    $(".free-projects").html(free_projects);
	  }
	}
	
	// New/Update project
	$('#new_project').submit(function(event) {
      event.preventDefault();
      var estimate = $(".estimate").attr("data-value");
	  if(typeof estimate != 'undefined'){$("#project_estimate_value").attr("value",estimate);}
      var $form = $(this), form_data = $form.serialize(), url = $form.attr('action');
      var method = (url=='/projects') ? "POST" : "PUT";
	  $('#new_project_modal').modal('hide');
   	  $.ajax({url:url, data:form_data,
	    type: method,
   	    success: function(data) {
	      var project = $('<ul>'+data+'</ul>').find('.project');
		  var limit = $('<div>'+data+'</div>').find('.limit');
		  if(project.length > 0) {
		    var project_id = project.attr("data-id");
		    var project_element = $("#project_"+project_id);
		    if( project_element.length > 0 ) {
		      project_element.replaceWith(project);
		    } else {
		    	$(".projects").prepend(project);
	  	    }
		    if($(".projects li:not(.empty)").length > 0){$(".projects li.empty").hide();}
  		    update_sidebar_info(data);
		  } else if((limit.length > 0) && confirm(limit.text())) {
			  	window.location.href = '/subscription'; return;
		  }	
   	    }
   	  }).error(function() { alert("Something went wrong with your request. Please try again."); })
  	});

	$(".edit_project").submit(function(event){
		var estimate = $(".estimate").attr("data-value");
		if(typeof estimate != 'undefined'){$("#project_estimate_value").attr("value",estimate);}
	});
	
	// Delete project
	$("#projects").on("click",".actions .delete",function(){
		var project = $(this).parents(".project"), project_id = project.attr("data-id");
		$.ajax({ url: '/projects/'+project_id,
		  type: "DELETE",
		  success: function(data){
			project.find('.delete').tooltip('hide');
			project.remove();
			if($(".projects li:not(.empty)").length == 0) {$(".projects li.empty").show();}
			update_sidebar_info(data)
		  }
		});
	});
	
	// Edit project
	$("#projects").on("click",".actions .edit",function(){
		var project = $(this).parents(".project"),
	    project_id = project.attr("data-id"),
	    name = project.attr("data-name"),
	    client = project.attr("data-client"),
	    exact_value = project.attr("data-exact-value"),
	    estimate_value = project.attr("data-estimate-value");
		$("#new_project").attr("action","/projects/"+project_id);
		$("#new_project #project_name").attr("value",name);
		$("#new_project #project_client").attr("value",client);
		if(typeof exact_value != 'undefined'){$("#new_project #project_exact_value").attr("value",exact_value);}
		if(typeof estimate_value != 'undefined'){$("#new_project .estimate").attr({"data-value":exact_value,"class":"estimate estimated_"+estimate_value});}
		$("#new_project_modal").modal("show");
	});
	
	// Update
	$("#projects, #sidebar").on("click",".states li, .actions .lost, .actions .hold, a.reactivate, a.unhold",function(){
		var $this = $(this);
		var state = $(this).attr('data-state');
		var project = $(this).parents(".project"), project_id = project.attr("data-id");
		$.ajax({ url: '/projects/'+project_id+'/transitions/', data:{"transition":{"enter_state":state}},
		  type: "POST",
		  success: function(data){
			$this.tooltip('hide');
			if((state=='lost') || (state=='won')){
				project.remove();
			} else if (state=='reactivate') {
				window.location.href = '/projects'; return;
			}
			else {
				var updated_project = $('<ul>'+data+'</ul>').find('.project');
				var note = updated_project.find('.note');
				project.replaceWith(updated_project);
				if(typeof note != undefined) {
					var pos = (parseInt(updated_project.find('.current').attr('class')[4])-1) * 120 - 250 + 60;
					note.css("left", pos+'px');
				}
			}
			if($(".projects li:not(.empty)").length == 0){$(".projects li.empty").show();}
			update_sidebar_info(data)
		  }
		});
	});
	
	// Close Note
	$("#projects").on("click",".note a.cancel",function(){
		$(this).parents(".note").remove();
	});
	
	// Add Note
	$("#projects").on("submit",".edit_transition",function(event){
		event.preventDefault();
		var $form = $(this), form_data = $form.serialize(), url = $form.attr('action');
		$.ajax({url:url, data:form_data,
		    type: "PUT",
	   	    success: function(data) {
				$form.parents(".note").remove();
			}});
	});
});