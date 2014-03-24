require 'test_helper'

class PupilsControllerTest < ActionController::TestCase
  setup do
    @pupil = pupils(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:pupils)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create pupil" do
    assert_difference('Pupil.count') do
      post :create, pupil: { admin_permissions: @pupil.admin_permissions, first_name: @pupil.first_name, gender: @pupil.gender, last_name: @pupil.last_name, mail_address: @pupil.mail_address, password_digest: @pupil.password_digest, password_resetkey: @pupil.password_resetkey }
    end

    assert_redirected_to pupil_path(assigns(:pupil))
  end

  test "should show pupil" do
    get :show, id: @pupil
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @pupil
    assert_response :success
  end

  test "should update pupil" do
    patch :update, id: @pupil, pupil: { admin_permissions: @pupil.admin_permissions, first_name: @pupil.first_name, gender: @pupil.gender, last_name: @pupil.last_name, mail_address: @pupil.mail_address, password_digest: @pupil.password_digest, password_resetkey: @pupil.password_resetkey }
    assert_redirected_to pupil_path(assigns(:pupil))
  end

  test "should destroy pupil" do
    assert_difference('Pupil.count', -1) do
      delete :destroy, id: @pupil
    end

    assert_redirected_to pupils_path
  end
end
