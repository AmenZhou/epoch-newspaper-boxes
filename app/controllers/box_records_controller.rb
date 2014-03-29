class BoxRecordsController < ApplicationController
  before_action :set_box_record, only: [:show, :edit, :update, :destroy]

  # GET /box_records
  # GET /box_records.json
  def index
    @box_records = BoxRecord.all
  end

  # GET /box_records/1
  # GET /box_records/1.json
  def show
  end

  # GET /box_records/new
  def new
    @box_record = BoxRecord.new
  end

  # GET /box_records/1/edit
  def edit
  end

	def view_records
		@box_records = BoxRecord.all
	end
  # POST /box_records
  # POST /box_records.json
  def create
    @box_record = BoxRecord.new(box_record_params)
		@newspaper_box = NewspaperBox.find_by(params[:newspaper_box_id])
		@newspaper_box.box_records << @box_record
    respond_to do |format|
      if @box_record.save
        format.html { redirect_to @box_record, notice: 'Box record was successfully created.' }
        format.json { render action: 'show', status: :created, location: @box_record }
      else
        format.html { render action: 'new' }
        format.json { render json: @box_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /box_records/1
  # PATCH/PUT /box_records/1.json
  def update
    respond_to do |format|
      if @box_record.update(box_record_params)
        format.html { redirect_to @box_record, notice: 'Box record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @box_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /box_records/1
  # DELETE /box_records/1.json
  def destroy
    @box_record.destroy
    respond_to do |format|
      format.html { redirect_to box_records_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_box_record
      @box_record = BoxRecord.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def box_record_params
      params.require(:box_record).permit(:newspaper_box_id, :date_t, :quantity, :remark)
    end
end
