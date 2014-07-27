class NewspaperBoxesController < ApplicationController
  before_action :set_newspaper_box, only: [:show, :edit, :update, :destroy]

  # GET /newspaper_boxes
  # GET /newspaper_boxes.json
  def index
    @newspaper_boxes = NewspaperBox.all
  end

  def upload_file
    NewspaperBox.upload(params[:file])
    redirect_to action: :index
  end
  # GET /newspaper_boxes/1
  # GET /newspaper_boxes/1.json
  def show
  end

  # GET /newspaper_boxes/new
  def new
    @newspaper_box = NewspaperBox.new
  end

  # GET /newspaper_boxes/1/edit
  def edit
  end

  # POST /newspaper_boxes
  # POST /newspaper_boxes.json
  def create
    @newspaper_box = NewspaperBox.new(newspaper_box_params)

    respond_to do |format|
      if @newspaper_box.save
        format.html { redirect_to @newspaper_box, notice: 'Newspaper box was successfully created.' }
        format.json { render action: 'show', status: :created, location: @newspaper_box }
      else
        format.html { render action: 'new' }
        format.json { render json: @newspaper_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /newspaper_boxes/1
  # PATCH/PUT /newspaper_boxes/1.json
  def update
    respond_to do |format|
      if @newspaper_box.update(newspaper_box_params)
        format.html { redirect_to @newspaper_box, notice: 'Newspaper box was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @newspaper_box.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /newspaper_boxes/1
  # DELETE /newspaper_boxes/1.json
  def destroy
    @newspaper_box.destroy
    respond_to do |format|
      format.html { redirect_to newspaper_boxes_url }
      format.json { head :no_content }
    end
  end

  def report
    @report = NewspaperBox.report
  end

  def zipcode_report
    @zipcode_report = NewspaperBox.zipcode_report
  end

  def map
    @citys = NewspaperBox.pluck(:city).compact.uniq
    @selected_city = params[:city]
    boxes = params[:city].present? ? NewspaperBox.by_city(params[:city]) : NewspaperBox.all
    @locations = boxes.map do |np|
      location = {}
      location['latitude'] = np.latitude 
      location['longitude'] = np.longitude
      location['paper_count'] = np.week_count
      location['address'] = np.display_address
      location['icon'] = np.week_count < NewspaperBox.avg_week_count ? 'yellow' : 'red'
      location
    end
    respond_to do |format|
        format.html {  }
        format.json { render json: @locations.to_json  }
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_newspaper_box
      @newspaper_box = NewspaperBox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newspaper_box_params
      params.require(:newspaper_box).permit(:address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :iron_box, :plastic_box, :selling_box, :paper_shelf, :remark, :mon, :tue, :wed, :thu, :fri, :sat, :sun)
    end
end
