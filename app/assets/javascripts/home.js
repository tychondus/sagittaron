$(document).ready(function() {
   console.debug("Ready!");
   $('#jquery-wrapped-fineuploader').fineUploader({
      request: {
         customHeaders: { 'X-CSRF-Token' : $('meta[name="csrf-token"]').attr('content')
         },
         endpoint: '/home/upload'
      }
   });
});

function fileValidation() {
   console.debug("onclick was successful");
}
