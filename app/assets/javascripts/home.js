$(document).ready(function() {
   uploadEvent()
});

function uploadEvent() {
   $('#jquery-wrapped-fineuploader').fineUploader({
      request: {
         customHeaders: { 'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
         },
         endpoint: '/files/upload'
      },
      multiple: false,
      text: { uploadButton: 'Upload' }
   }).on('complete', function(event, id, filename, responseJSON) {
      if (responseJSON.success) {
         console.debug('Success');
      }
      else {
         console.debug('Failure');
      }
      $("div .qq-upload-list").each(function() {
         $("li:not(:last)", this).hide();
      });
   });

}
