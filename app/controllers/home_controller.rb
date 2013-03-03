class HomeController < ApplicationController
  def index
     @files = UserFile.all

     respond_to do |format|
        format.html
        format.json {render json: @files }
     end
  end

  def upload
     dir_path = 'app/assets/files'
     @tmp_param = { 'name'=> params[:qqfile],
                    'size'=> params[:qqtotalfilesize],
                    'uuid'=> params[:qquuid]
                  }
     #save to table
     @file = UserFile.new(@tmp_param)
     if @file.save 
        @is_file_saved = true
     end

     #check if the dir exists otherwise create it
     Dir.mkdir(File.join(Dir.getwd, dir_path)) unless File.directory?(File.join(Dir.getwd, dir_path))
     
     #save to fs 
     begin
        newfile = File.open(File.join(dir_path, @file.uuid), "wb")
        str = request.body.read
        newfile.write(str)
     rescue IOError => e
        puts "failed to write " + newfile
     ensure
        unless newfile.nil?
          newfile.close
          @is_file_exists = true
        end
     end

     if @is_file_saved and @is_file_exists
        render :json => { success: true }.to_json 
     else
        render :json => { success: false }.to_json
     end
  end
end
