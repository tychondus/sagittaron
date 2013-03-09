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
      console.debug(responseJSON);
      if (responseJSON.success) {
         var element = uploadedFiles(responseJSON.file);
         $('table').append(element);
      }
      $("div .qq-upload-list").each(function() {
         $("li:not(:last)", this).hide();
      });
   });

}

/* currently this only handles one file object. For multiple file object, add a for loop.
 * Ensure the controller can handle multiple files.
 */
function uploadedFiles(fileObj) {
   var element = '<tr>\n' +
                 '  <td>' + fileObj.name + '</td>\n' +
                 '  <td>' + fileObj.size + '</td>\n' +
                 '  <td>' + fileObj.file_location + '</td>\n';

   if (fileObj.thumb_location) {
      element += '  <td>' + fileObj.thumb_location + '</td>\n';
   }
   else {
      element += '  <td></td>\n';
   }
   if (fileObj.description) {
      element += '  <td>' + fileObj.description + '</td>\n';
   }
   else {
      element += '  <td></td>\n';
   }
   element += '  <td>\n' + 
              '    <a href="/user_files/' + fileObj.id + '">Show</a>\n'+
              '  </td>\n' +
              '  <td>\n' +
              '    <a href="/user_files/' + fileObj.id + '/edit">Edit</a>\n' +
              '  </td>\n' +
              '  <td>\n' +
              '    <a href="/user_files/' + fileObj.id + '/delete">Destroy</a>\n' + 
              '  </td>\n';
   element += '</tr>\n';

   return element;
}
