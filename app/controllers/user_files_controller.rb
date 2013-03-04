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
     dir_path = 'app/assets/files'
     #save to table
     @file = UserFile.new( {:name => params[:qqfile], :size => params[:qqtotalfielsize], :uuid => params[:qquuid] })
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
        #failed to write to disk, then delete the record
        @file.delete
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
