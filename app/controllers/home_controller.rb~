class HomeController < ApplicationController
  def index
  end

  def upload
     puts params
     dir_path = 'app/assets/files'
     filename = params[:qquuid]
    
     Dir.mkdir(File.join(Dir.getwd, dir_path)) unless File.directory?(File.join(Dir.getwd, dir_path))

     newfile = File.open(File.join(dir_path, filename), "wb")
     str = request.body.read
     puts str
     newfile.write(str)
     newfile.close()
     
     render :json => { success: true }.to_json 
  end
end
