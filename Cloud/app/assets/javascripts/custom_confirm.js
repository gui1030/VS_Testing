(function ($) {
    $.rails.allowAction = function(link) {
        if (!link.attr('data-confirm')) {
            return true;
        }
            $.rails.showConfirmDialog(link);
        return false;
    };

    $.rails.confirmed = function(link) {
        link.removeAttr('data-confirm');
        return link.trigger('click.rails');
    }

    $.rails.showConfirmDialog = function(link) {
        var message = link.attr('data-confirm');
        var modalHeader = '';
        modalHeader =
            '<div class="modal-header">' +
                '<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>' +
                '<h4 class="modal-title"></h4>' +
            '</div>';
        var modalHTML =
                '<div class="confirmation-modal modal fade" id="confirmationDialog" role="dialog">' +
                    '<div class="modal-dialog">' +
                        '<div class="modal-content">' +
                            modalHeader +
                            '<div class="modal-body">'+ message +'</div>' +
                            '<div class="modal-footer">' +
                                '<button class="confirm btn btn-primary" type="button" data-dismiss="modal">Yes</button>' +
                                '<button class="cancel btn btn-default" type="button" data-dismiss="modal">No</button>' +
                            '</div>' +
                        '</div>' +
                    '</div>' +
                '</div>';
        var modal = $(modalHTML).modal();
        $("body").append(modal);
        modal.modal('show');
        return $('#confirmationDialog .confirm').on('click', function() {
        	$('.loading-indicator').show();
            return $.rails.confirmed(link)
        });
    };
})(jQuery);
