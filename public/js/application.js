$(document).ready(function(){
  $('#create').submit(function(event){
  	 event.preventDefault(); 
  	 
  	 var data =  {
       name : $('#name').val(),
       location : $('#location').val(),
       starts_at : $('#starts_at').val(),
       ends_at : $('#ends_at').val()
       }

       $.post('/create_event',data,function(response) {
         $('#event_list > li:first-child').prepend(response)
       });
     $('#name').prop('value',''),
     $('#location').prop('value',''),
     $('#starts_at').prop('value',''),
     $('#ends_at').prop('value','')
    });   
});
