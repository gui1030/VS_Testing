$(() => {
  $('input[name="account_user[account_admin]"]').on('switchChange.bootstrapSwitch', _ => {
    $('#account_user_permissions').collapse('toggle');
  });
})
