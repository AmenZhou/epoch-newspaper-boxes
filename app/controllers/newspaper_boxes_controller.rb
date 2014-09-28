class NewspaperBoxesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_newspaper_box, only: [:show, :edit, :update]
  before_action :set_newspaper_box_for_trash_bin, only: [:recovery, :destroy]
  before_action :is_admin?, except: [:map]
  
  helper_method :sum_array
  # GET /newspaper_boxes
  # GET /newspaper_boxes.json
  def index
    redirect_to newspaper_boxes_path({table_type: "boxes"})
  end

  def param_hand
    @newspaper_boxes = NewspaperHand.all.order("sort_num").page(params[:page]).per(25)
    newspaper_sum
  end
  
  def param_box
     @newspaper_boxes = NewspaperBox.all.order("sort_num")
    if params['zip_code'].present?
      @selected_zip_code = params['zip_code']
      @newspaper_boxes = @newspaper_boxes.where(zip: @selected_zip_code)
    end
    if params['city'].present?
      @selected_city = params['city']
      @newspaper_boxes = @newspaper_boxes.where(city: @selected_city)
    end

    if params['borough'].present?
      @selected_borough = params['borough']
      @newspaper_boxes = @newspaper_boxes.where(borough_detail: @selected_borough)
    end
    
    if params['trash'].present?
      @selected_trash = params['trash']
      @newspaper_boxes = @newspaper_boxes.unscoped.where(trash: true)
    end
    
    newspaper_sum
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
    @nb_id = @newspaper_box.id
    if @newspaper_box.trash
      @newspaper_box.destroy
      get_newspaper_boxes_n_sum(true)
    else
      @newspaper_box.update(trash: true)
      get_newspaper_boxes_n_sum(false)
    end
    respond_to do |format|
      format.js
      format.json { head :no_content }
    end
  end

  def map
    @citys = NewspaperBox.pluck(:borough_detail).compact.uniq.delete_if{|x| x.blank?}
    @selected_city = params[:city]
    boxes = params[:city].present? ? NewspaperBox.by_borough(params[:city]) : NewspaperBox.all
    @locations = boxes.map do |np|
      location = {}
      location['latitude'] = np.latitude 
      location['longitude'] = np.longitude
      location['paper_count'] = np.week_count
      location['address'] = np.display_address
      #location['icon'] = np.week_count < NewspaperBox.avg_week_count ? 'yellow' : 'red'
      location['icon'] = np.is_newspaper_box? ? 'yellow' : 'red'
      location
    end
    respond_to do |format|
        format.html {  }
        format.json { render json: @locations.to_json  }
      end
  end

  def export_data
    file_path = NewspaperBox.export_data
    send_file(file_path)
  end
  
  def sum_array
    %w(iron_box plastic_box selling_box paper_shelf mon tue wed thu fri sat sun)
  end
  
  def recovery
    @newspaper_box.trash = false
    @nb_id = @newspaper_box.id
    if @newspaper_box.save
     # flash[:success] = "Recovery Successfully"
      @result = true
    else
     # flash[:error] = "Recovery Failed"
      @result = false
    end
    get_newspaper_boxes_n_sum(true)
    respond_to do |format|
      format.js
    end
  end
  
  private
  def get_newspaper_boxes_n_sum(trash=false)
    @newspaper_boxes = NewspaperBox.unscoped.where(trash: trash)
    newspaper_sum
  end
  
  def newspaper_sum
    @newspaper_sum = {}
    sum_array.each do |week_day|
      @newspaper_sum.send( :[]=, week_day.to_sym, @newspaper_boxes.sum(week_day.to_sym))
    end
  end
  
    def set_newspaper_box_for_trash_bin
      @newspaper_box = NewspaperBox.unscoped.find(params[:id])
    end
  
    # Use callbacks to share common setup or constraints between actions.
    def set_newspaper_box
      @newspaper_box = NewspaperBox.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def newspaper_box_params
      params.require(:newspaper_box).permit(:address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :iron_box, :plastic_box, :selling_box, :paper_shelf, :remark, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sort_num)
    end
 
    def is_admin?
      redirect_to root_path  unless current_user.is_admin?
    end
end
