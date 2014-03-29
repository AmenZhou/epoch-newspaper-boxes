require 'test_helper'

class BoxRecordsControllerTest < ActionController::TestCase
  setup do
    @box_record = box_records(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:box_records)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create box_record" do
    assert_difference('BoxRecord.count') do
      post :create, box_record: { date_t: @box_record.date_t, no: @box_record.no, quantity: @box_record.quantity, remark: @box_record.remark }
    end

    assert_redirected_to box_record_path(assigns(:box_record))
  end

  test "should show box_record" do
    get :show, id: @box_record
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @box_record
    assert_response :success
  end

  test "should update box_record" do
    patch :update, id: @box_record, box_record: { date_t: @box_record.date_t, no: @box_record.no, quantity: @box_record.quantity, remark: @box_record.remark }
    assert_redirected_to box_record_path(assigns(:box_record))
  end

  test "should destroy box_record" do
    assert_difference('BoxRecord.count', -1) do
      delete :destroy, id: @box_record
    end

    assert_redirected_to box_records_path
  end
end
