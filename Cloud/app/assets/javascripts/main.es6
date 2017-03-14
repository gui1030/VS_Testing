$(() => {
  $('[data-toggle="tooltip"]').tooltip()
  $('input:checkbox:not(.no-switch)').bootstrapSwitch();
  $('[data-behaviour~=datepicker]').datepicker();
  $('[data-behaviour~=timepicker]').timepicker();
  var clipboard = new Clipboard('.btn-clipboard');
  clipboard.on('success', function(e) {
    e.clearSelection();
  });
});
