require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
  test "full title helper" do
    assert_equal full_title,         "TSHA Interpreters"
    assert_equal full_title("Help"), "Help | TSHA Interpreters"
  end
end
