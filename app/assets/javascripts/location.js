$(function() {
    $(document).on('change', '#is_public', function() {
        if(this.checked) {
            $('#shared_users').prop('disabled', 'disabled');
        } else {
            $('#shared_users').prop('disabled', false);
        }
    });
});
