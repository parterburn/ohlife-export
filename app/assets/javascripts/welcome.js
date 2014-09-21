$(document).on('submit','form#download_images',function(){
  $('#submit_form').addClass('disabled');
  $('#source').attr('readonly', 'true');
  $('#submit_form').attr('readonly', 'true');  
  setTimeout(function(){
    $('#source').val('');
    $('#source').removeAttr('readonly');
    $('#submit_form').removeAttr('readonly');
    $('#submit_form').removeClass('disabled');
  }, 5000);
});