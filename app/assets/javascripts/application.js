// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap
//= require_tree .


!function ($) {

  $(function(){


  		
				




	    // tooltip setup
	    $('a[rel=tooltip]').tooltip({
	      placement: "bottom"
	    })

	    $('abbr[rel=tooltip]').tooltip({
	      placement: "bottom"
	    })

	    $('a[rel=popover].org-popover').popover({
	    	placement: "left",
	    	trigger: 'hover'
	    })

	    $('a[rel=popover].home-org-popover').popover({
	    	placement: "top",
	    	trigger: 'hover'
	    })



	    // search bar setup
	    var $search_bar_input = $('#search_bar_input');

		$search_bar_input.focus(function(e){
		   $(this).animate({width:'200px'}, 500);
		});

		$search_bar_input.blur(function(e){
		   $(this).animate({width:'130px'}, 300);
		});

		$('#search_org').click(function(e){
			$('#search_bar_type').val('org');
			$search_bar_input.attr("placeholder", "Search Organizations");
		   alert('Searching organizations: the type input of the search form has been set to org.');	 
		});

		$('#search_job').click(function(e){
			$('#search_bar_type').val('job');
			$search_bar_input.attr("placeholder", "Search Jobs");
		   alert('Searching jobs: the type input of the search form has been set to job.');	 
		});

		$('#search_proj').click(function(e){
			$('#search_bar_type').val('proj');
			$search_bar_input.attr("placeholder", "Search Projects");
		   alert('Searching projects: the type input of the search form has been set to proj.');	 
		});


		// seach filters
		$('#search_filters li').click(function(e) {	
			$(this).toggleClass('active'); // toggle this filter on or off
			
			$filters = $('ul.filters li.active'); // gather all active filters
			var new_ids = "";
			$filters.each(function() {  
				new_ids += $(this).attr('id') + ','  // acumulate into a string to pass to form
			})
			new_ids = new_ids.substring(0, new_ids.length - 1);  // remove ending comma
			
			//alert(new_ids);
			$('#filters_ids').val(new_ids);
			$('#search_orgs').submit();
			$('#search_jobs').submit();
			$('#search_projects').submit();

		});


		/*
		function stripCommas(s) {
			var s_new = s;
			if (s_new.charAt(0) == ',')
				s_new = s_new.substring(1, s_new.length - 1);  // remove starting comma if existent
			if (s_new.charAt(s_new.length-1) == ',')
				s_new = s_new.substring(0, s_new.length - 2);  // remove ending comma if existent
			return s_new;
		}
		*/

	    


  })
}(window.jQuery)