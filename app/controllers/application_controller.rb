class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  helper_method :sum_array

  def get_newspaper_bases_n_sum(trash=false)
    @newspaper_bases = NewspaperBase.unscoped.where(trash: trash, type: @class_type)
    newspaper_sum
  end
  
  def newspaper_sum
    @newspaper_sum = {}
    sum_array.each do |week_day|
      @newspaper_sum.send( :[]=, week_day.to_sym, @newspaper_bases.sum(week_day.to_sym))
    end
  end

  def sum_array(type='box')
    type == 'box' ? %w(iron_box plastic_box selling_box paper_shelf mon tue wed thu fri sat sun) : %w(mon tue wed thu fri sat sun)
  end
end
