function prepareModal(link) {
  var button = $(link);
  // Extract info from data-* attributes
  var title = button.data('title');
  var image_src = button.data('large-src');
  // Update the modal's content.
  var modal = $('#photoModal');
  modal.find('.modal-title').text(title);
  modal.find('.modal-body img').attr('src', image_src);
  // Show the modal
  modal.find('.modal-body img').on('load', function() {
    modal.modal('show');
  });
}

$(function() {
  $('#photoModal').on('shown.bs.modal', function (event) {
    var modal = $(this);

    modal.find('.modal-dialog').css({
      'width': modal.find('.modal-body img').width() + 30 + 'px',
      'height':'auto',
      'max-height':'100%'
    });
  });

});
