$( document ).ready(function() {

  $('#source').on('keyup',function() {
    if ($(this).val().indexOf("<div class=\"entry") > -1) {
      $('.s-form button').removeAttr('disabled');
      $('.s-form button').removeClass('disabled');
    } else {
      $('.s-form button').attr('disabled','disabled');
      $('.s-form button').addClass('disabled');
    }
    $(this).scrollTop(0);
  });

  $('#export_text_form').on('click',function() {
    $("#export_ohlife").attr('action','/export');
    $("#export_ohlife").submit();
  });

  $('#export_images_form').on('click',function() {
    $("#export_ohlife").attr('action','/zip');
    $("#export_ohlife").submit();
  });

  $(document).on('submit','form#export_ohlife',function(){
    $('#source').attr('readonly', 'true');
    $('.s-form button').attr('disabled', 'disabled');
    $('.s-form button').addClass('disabled');
    setTimeout(function(){
      $('#source').removeAttr('readonly');
      $('.s-form button').removeAttr('disabled');
      $('.s-form button').removeClass('disabled');
    }, 2000);
  });

});