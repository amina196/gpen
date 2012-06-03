class SearchonprojectsController < ApplicationController
  # GET /searchonprojects
  # GET /searchonprojects.json
  def index
    @searchonprojects = Searchonproject.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @searchonprojects }
    end
  end

  # GET /searchonprojects/1
  # GET /searchonprojects/1.json
  def show
    @searchonproject = Searchonproject.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @searchonproject }
    end
  end

  # GET /searchonprojects/new
  # GET /searchonprojects/new.json
  def new
    @searchonproject = Searchonproject.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @searchonproject }
    end
  end

  # GET /searchonprojects/1/edit
  def edit
    @searchonproject = Searchonproject.find(params[:id])
  end

  # POST /searchonprojects
  # POST /searchonprojects.json
  def create
    @searchonproject = Searchonproject.new(params[:searchonproject])

    respond_to do |format|
      if @searchonproject.save
        format.html { redirect_to @searchonproject, notice: 'Searchonproject was successfully created.' }
        format.json { render json: @searchonproject, status: :created, location: @searchonproject }
      else
        format.html { render action: "new" }
        format.json { render json: @searchonproject.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /searchonprojects/1
  # PUT /searchonprojects/1.json
  def update
    @searchonproject = Searchonproject.find(params[:id])

    respond_to do |format|
      if @searchonproject.update_attributes(params[:searchonproject])
        format.html { redirect_to @searchonproject, notice: 'Searchonproject was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @searchonproject.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /searchonprojects/1
  # DELETE /searchonprojects/1.json
  def destroy
    @searchonproject = Searchonproject.find(params[:id])
    @searchonproject.destroy

    respond_to do |format|
      format.html { redirect_to searchonprojects_url }
      format.json { head :no_content }
    end
  end
end
