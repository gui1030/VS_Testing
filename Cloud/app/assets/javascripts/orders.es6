$(() => {
  $('[data-countdown]').each(function(){
    var $timer = $(this);
    var deadline = moment($timer.data('countdown'));

    function updateTimer() {
      var duration = moment.duration(deadline.diff(moment()));
      if (duration < moment.duration(500)) {
        clearInterval(interval);
      }
      $timer.html(duration.format('mm:ss', { trim: false, forceLength: true}));
    }

    var interval = setInterval(updateTimer, 100);
    $(document).on('page:before-change', _ => clearInterval(interval));

  });

  $('.btn-tracking').on('ajax:send', (e) => {
    $(e.target).find('.spinner').removeClass('hide')
  }).on('ajax:complete', (e) => {
    $(e.target).find('.spinner').addClass('hide')
  }).on('ajax:error', (e, status, error) => {
    $('.shipment-events').html('An error occurred while looking up tracking info. Please try again later.')
  });
});
