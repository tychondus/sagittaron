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
     puts today
     dir_paths = [ 'public/files/uploaded', 'public/files/thumbs' ]
      
     #check if the dir exists otherwise create it
     dir_paths.each do |path|
        FileUtils.mkdir_p(File.join(Dir.getwd, path)) unless File.directory?(File.join(Dir.getwd, path))
     end

     dir_today = FileUtils.mkdir_p(File.join(File.join(Dir.getwd, dir_paths[0]), today))
     uploaded_file = save_to_fs(File.join(dir_paths[0], File.join(today, params[:qquuid])), "wb", env['action_dispatch.request.request_parameters']['qqfile'])
     unless uploaded_file.nil?
        @is_file_exists = true
        #save to table
        @file = UserFile.new( { :name => params[:qqfile], 
                                :size => params[:qqtotalfilesize], 
                                :uuid => File.join(today,params[:qquuid]) 
                              } )
        if @file.save 
           @is_file_saved = true
        end
     end

     if @is_file_saved and @is_file_exists
        render :json => { success: true, file: @file }.to_json 
     else
        render :json => { success: false }.to_json
     end
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
end
