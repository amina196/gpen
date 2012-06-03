require 'test_helper'

class SearchonprojectsControllerTest < ActionController::TestCase
  setup do
    @searchonproject = searchonprojects(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:searchonprojects)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create searchonproject" do
    assert_difference('Searchonproject.count') do
      post :create, searchonproject: @searchonproject.attributes
    end

    assert_redirected_to searchonproject_path(assigns(:searchonproject))
  end

  test "should show searchonproject" do
    get :show, id: @searchonproject
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @searchonproject
    assert_response :success
  end

  test "should update searchonproject" do
    put :update, id: @searchonproject, searchonproject: @searchonproject.attributes
    assert_redirected_to searchonproject_path(assigns(:searchonproject))
  end

  test "should destroy searchonproject" do
    assert_difference('Searchonproject.count', -1) do
      delete :destroy, id: @searchonproject
    end

    assert_redirected_to searchonprojects_path
  end
end
