$(() => {
  $('[data-replace]').each(function(){
    let path = $(this).data('replace');
    fetch(path, {credentials: 'same-origin'})
    .then(response => {
      return response.ok ? response.text() : 'n/a';
    })
    .then(text => {
      let $parent = $(this).parent();
      $(this).replaceWith(text);
      $parent.find('[data-toggle="tooltip"]').tooltip()
    });
  });
});
