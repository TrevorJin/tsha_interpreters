require 'test_helper'

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  
  def setup
    @base_title = 'TSHA Interpreters'
  end

  test 'should get home' do
    get static_pages_home_url
    assert_successful_application_layout
    assert_select 'title', "#{@base_title}"
  end

  test 'should get help' do
    get static_pages_help_url
    assert_successful_application_layout
    assert_select 'title', "Help | #{@base_title}"
  end

  test 'should get about' do
    get static_pages_about_url
    assert_successful_application_layout
    assert_select 'title', "About | #{@base_title}"
  end
end
