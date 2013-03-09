class UserFilesController < ApplicationController
  # GET /user_files
  # GET /user_files.json
  def index
    @user_files = UserFile.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @user_files }
    end
  end

  # GET /user_files/1
  # GET /user_files/1.json
  def show
    @user_file = UserFile.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @user_file }
    end
  end

  # GET /user_files/new
  # GET /user_files/new.json
  def new
    @user_file = UserFile.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user_file }
    end
  end

  # GET /user_files/1/edit
  def edit
    @user_file = UserFile.find(params[:id])
  end

  # POST /user_files
  # POST /user_files.json
  def create
    @user_file = UserFile.new(params[:user_file])

    respond_to do |format|
      if @user_file.save
        format.html { redirect_to @user_file, notice: 'User file was successfully created.' }
        format.json { render json: @user_file, status: :created, location: @user_file }
      else
        format.html { render action: "new" }
        format.json { render json: @user_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /user_files/1
  # PUT /user_files/1.json
  def update
    @user_file = UserFile.find(params[:id])

    respond_to do |format|
      if @user_file.update_attributes(params[:user_file])
        format.html { redirect_to @user_file, notice: 'User file was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user_file.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /user_files/1
  # DELETE /user_files/1.json
  def destroy
    @user_file = UserFile.find(params[:id])
    @user_file.destroy

    respond_to do |format|
      format.html { redirect_to user_files_url }
      format.json { head :no_content }
    end
  end

  def upload
     time = Time.new
     today = time.strftime('%Y-%m-%d')
     dir_paths = [ 'public/files/uploaded', 'public/files/thumbs' ]
      
     #check if the dir exists otherwise create it
     dir_paths.each do |path|
        FileUtils.mkdir_p( File.join( Dir.getwd, File.join( path, today ) ) ) unless File.directory?( File.join( Dir.getwd, File.join( path , today ) ) )
     end
     
     #save incoming file to dir_paths[0]
     uploaded_file = save_to_fs( File.join( dir_paths[0], File.join( today, params[:qquuid] ) ), 
                                 "wb", 
                                 env['action_dispatch.request.request_parameters']['qqfile'] )
     Rails.logger.debug("uploaded_file = "  + uploaded_file.inspect)
     
     #if incoming file is of type image. create a thumbnail
     thumb_file = create_thumbnail( env['action_dispatch.request.request_parameters']['qqfile'],
                                    File.extname(params[:qqfile]),
                                    '75x75',
                                    File.join( dir_paths[1], File.join( today, params[:qquuid] ) ) )
     Rails.logger.debug("thumb_file = " + thumb_file.inspect)

     unless uploaded_file.nil?
        @is_file_exists = true
        
        #create paramaters to pass into UserFile object
        validated_params = create_param(params, dir_paths, today, thumb_file)
        Rails.logger.debug ("validated_params = " + validated_params.to_s)
        
        #create a UserFile object
        @file = UserFile.new(validated_params)
        Rails.logger.debug ("record values = " + @file.attributes.inspect)
        
        #save to db
        if @file.save 
           @is_file_saved = true
        else
           Rails.logger.error("failed to save " + @file.attributes.inspect)
        end
     end

     if @is_file_saved and @is_file_exists
        render :json => { success: true, file: @file }.to_json 
     else
        render :json => { success: false }.to_json
     end
  end

  private
  def create_param(in_params, paths, today_dir, is_thumb) 
     param = { :name => in_params[:qqfile],
               :size => in_params[:qqtotalfilesize],
               :file_location => File.join( paths[0], File.join( today_dir, in_params[:qquuid] ) ) }
     if is_thumb
        param.merge!( :thumb_location => File.join( paths[1], File.join( today_dir, in_params[:qquuid] ) ) )
     end
     return param
  end

  private
  def save_to_fs(name, mode, stream)
     return_val = nil
     begin
        newfile = File.open(name, mode)
        newfile.write(stream.read)
     rescue IOError => e
        Rails.logger.error(e)
     ensure
        unless newfile.nil?
           newfile.close
           return_val = newfile
        end
     end
     return return_val
  end

  private
  def create_thumbnail(stream, ext, size, output_file)
     return_val = nil
     ext_names = [ '.jpg', '.jpeg', '.tiff', '.bmp', '.png' ]
     if ext_names.include? (ext.downcase)
        image = MiniMagick::Image.read(stream, ext)
        image.combine_options do |thumb|
           thumb.resize size
           thumb.background "transparent"
           thumb.gravity "center"
           thumb.extent size
        end
        image.write(output_file)
        return_val = image
     end
     return return_val
  end
end
