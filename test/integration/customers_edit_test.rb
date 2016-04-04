require 'test_helper'

class CustomersEditTest < ActionDispatch::IntegrationTest

  def setup
    @regular_customer = customers(:hideaway)
  end

  test "unsuccessful edit" do
    customer_log_in_as(@regular_customer)
    get edit_customer_path(@regular_customer)
    assert_template 'customers/edit'
    patch customer_path(@regular_customer), customer: { customer_name:  "",
                                                        email: "foo@invalid",
                                                        contact_first_name: "",
    								                    contact_last_name:  "",
                                                        password:              "foo",
                                                        password_confirmation: "bar" }
    assert_template 'customers/edit'
  end

  test "successful edit with friendly forwarding" do
    get edit_customer_path(@regular_customer)
    customer_log_in_as(@regular_customer)
    assert_redirected_to edit_customer_path(@regular_customer)
    customer_name = "Larry's Lawnmowers"
    first_name  = "Fred"
    last_name = "Tucker"
    email = "foo@bar.com"
    patch customer_path(@regular_customer), customer: { customer_name:  customer_name,
                                                        email: email,
                                                        contact_first_name: first_name,
                                                        contact_last_name:   last_name,
                                                        password:              "",
                                                        password_confirmation: "" }
    assert_not flash.empty?
    assert_redirected_to @regular_customer
    @regular_customer.reload
    assert_equal customer_name,  @regular_customer.customer_name
    assert_equal email, @regular_customer.email
    assert_equal first_name,  @regular_customer.contact_first_name
    assert_equal last_name, @regular_customer.contact_last_name
  end
end
