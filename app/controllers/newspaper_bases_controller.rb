class NewspaperBasesController < ApplicationController
  helper_method :sum_array
  before_action :authenticate_user!
  #before_action :set_newspaper_base, only: [:show, :edit, :update]
  before_action :set_newspaper_base_for_trash_bin, only: [:recovery, :destroy]
  before_action :is_admin?, except: [:map]
  def index
    @table_type = params['table_type'] || 'boxes'
    if @table_type == 'boxes'
      @newspaper_bases = NewspaperBox.all.order("sort_num")
    elsif @table_type == 'hands'
      @newspaper_bases = NewspaperHand.all.order("sort_num")
    end
    filter_newspaper_base
    @newspaper_bases = @newspaper_bases.page(params[:page]).per(25)
    newspaper_sum
  end

  def new
    if params[:table_type].downcase.match('box')
      @table_type = 'newspaper_boxes'
    elsif params[:table_type].downcase.match('hand')
      @table_type = 'newspaper_hands'
    end
    @newspaper_base = NewspaperBase.new(type: params[:table_type])
  end

  private

  def sum_array(type='box')
    type == 'box' ? %w(iron_box plastic_box selling_box paper_shelf mon tue wed thu fri sat sun) : %w(mon tue wed thu fri sat sun)
  end

  def filter_newspaper_base
    if params['zip_code'].present?
      @selected_zip_code = params['zip_code']
      @newspaper_bases = @newspaper_bases.where(zip: @selected_zip_code)
    end
    if params['city'].present?
      @selected_city = params['city']
      @newspaper_bases = @newspaper_bases.where(city: @selected_city)
    end

    if params['borough'].present?
      @selected_borough = params['borough']
      @newspaper_bases = @newspaper_bases.where(borough_detail: @selected_borough)
    end

    if params['trash'].present?
      @selected_trash = params['trash']
      @newspaper_bases = @newspaper_bases.unscoped.where(trash: true)
    end
  end
  
  def get_newspaper_bases_n_sum(trash=false)
    @newspaper_bases = NewspaperBase.unscoped.where(trash: trash)
    newspaper_sum
  end
  
  def newspaper_sum
    @newspaper_sum = {}
    sum_array.each do |week_day|
      @newspaper_sum.send( :[]=, week_day.to_sym, @newspaper_bases.sum(week_day.to_sym))
    end
  end
  
  def set_newspaper_base_for_trash_bin
    @newspaper_base = NewspaperBox.unscoped.find(params[:id])
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_newspaper_base
    @newspaper_base = NewspaperBase.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def newspaper_base_params
    params.require(:newspaper_base).permit(:address, :city, :state, :zip, :borough_detail, :address_remark, :date_t, :deliver_type, :iron_box, :plastic_box, :selling_box, :paper_shelf, :remark, :mon, :tue, :wed, :thu, :fri, :sat, :sun, :sort_num, :building, :place_type)
  end

  def is_admin?
    redirect_to root_path  unless current_user.is_admin?
  end
end