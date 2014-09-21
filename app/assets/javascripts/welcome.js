$(document).on('submit','form#download_images',function(){
   $('#source').val('');
   $('#submit_form').addClass('disabled');
   console.log ('submitted');
});