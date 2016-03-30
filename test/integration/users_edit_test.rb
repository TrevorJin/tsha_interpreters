require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @regular_user = users(:archer)
  end

  test "unsuccessful edit" do
    log_in_as(@regular_user)
    get edit_user_path(@regular_user)
    assert_template 'users/edit'
    patch user_path(@regular_user), user: { first_name:  "",
    								        last_name:  "",
                                            gender: "",
                                            cell_phone: "",
                                            email: "foo@invalid",
                                            password:              "foo",
                                            password_confirmation: "bar" }
    assert_template 'users/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@regular_user)
    log_in_as(@regular_user)
    assert_redirected_to edit_user_path(@regular_user)
    first_name  = "Foo"
    last_name = "Bar"
    gender = "Male"
    cell_phone = "+18662466453"
    email = "foo@bar.com"
    patch user_path(@regular_user), user: { first_name:  first_name,
                                            last_name:   last_name,
                                            gender: gender,
                                            cell_phone: cell_phone,
                                            email: email,
                                            password:              "",
                                            password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @regular_user
    @regular_user.reload
    assert_equal first_name,  @regular_user.first_name
    assert_equal last_name, @regular_user.last_name
    assert_equal cell_phone, @regular_user.cell_phone
    assert_equal email, @regular_user.email
  end
end
