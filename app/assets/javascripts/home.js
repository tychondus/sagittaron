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
         console.debug('Success');
         var element = uploadedFiles(responseJSON.file);
         $('table').append(element);
      }
      else {
         console.debug('Failure');
      }
      $("div .qq-upload-list").each(function() {
         $("li:not(:last)", this).hide();
      });
   });

}

function uploadedFiles(fileObj) {
   console.debug(fileObj);
   console.debug(fileObj.name);
   console.debug(fileObj.description);
   console.debug(fileObj.description == null);
   console.debug(fileObj.description == 'null');
   var element = '<tr>\n' +
                 '  <td>' + fileObj.name + '</td>\n' +
                 '  <td>' + fileObj.size + '</td>\n' +
                 '  <td>' + fileObj.uuid + '</td>\n';

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
