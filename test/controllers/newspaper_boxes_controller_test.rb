require 'test_helper'

class NewspaperBoxesControllerTest < ActionController::TestCase
  setup do
    @newspaper_box = newspaper_boxes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:newspaper_boxes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create newspaper_box" do
    assert_difference('NewspaperBox.count') do
      post :create, newspaper_box: { address: @newspaper_box.address, address_remark: @newspaper_box.address_remark, borough_detail: @newspaper_box.borough_detail, box_type: @newspaper_box.box_type, city: @newspaper_box.city, date_t: @newspaper_box.date_t, deliver_type: @newspaper_box.deliver_type, no: @newspaper_box.no, remark: @newspaper_box.remark, state: @newspaper_box.state, zip: @newspaper_box.zip }
    end

    assert_redirected_to newspaper_box_path(assigns(:newspaper_box))
  end

  test "should show newspaper_box" do
    get :show, id: @newspaper_box
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @newspaper_box
    assert_response :success
  end

  test "should update newspaper_box" do
    patch :update, id: @newspaper_box, newspaper_box: { address: @newspaper_box.address, address_remark: @newspaper_box.address_remark, borough_detail: @newspaper_box.borough_detail, box_type: @newspaper_box.box_type, city: @newspaper_box.city, date_t: @newspaper_box.date_t, deliver_type: @newspaper_box.deliver_type, no: @newspaper_box.no, remark: @newspaper_box.remark, state: @newspaper_box.state, zip: @newspaper_box.zip }
    assert_redirected_to newspaper_box_path(assigns(:newspaper_box))
  end

  test "should destroy newspaper_box" do
    assert_difference('NewspaperBox.count', -1) do
      delete :destroy, id: @newspaper_box
    end

    assert_redirected_to newspaper_boxes_path
  end
end
