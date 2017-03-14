$(() => {
   if($('#report_frequency').val() == "daily"){
      $("#report_weekday").css('display','none')
      $("#report_day").css('display','none')
   } else if ($('#report_frequency').val() == "weekly" || $('#report_frequency').val() == "bi_weekly"){
    $("#report_weekday").css('display','block')
      $("#report_day").css('display','none')
   } else{
    $("#report_weekday").css('display','none')
    $("#report_day").css('display','block')
   }

   $('#report_frequency').change(function(){
      if($(this).val() == "daily"){
        $("#report_weekday").css('display','none')
        $("#report_day").css('display','none')
      } else if ($(this).val() == "weekly" || $(this).val() == "bi_weekly"){
        $("#report_weekday").css('display','block')
        $("#report_day").css('display','none')
      } else{
        $("#report_weekday").css('display','none')
        $("#report_day").css('display','block')
      }
   })
});
