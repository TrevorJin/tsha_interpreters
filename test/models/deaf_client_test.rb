require 'test_helper'

class DeafClientTest < ActiveSupport::TestCase
  def setup
    @deaf_client = DeafClient.new(first_name: 'Nancy', last_name: 'Drew',
                                  internal_notes: 'Good client',
                                  public_notes: 'Bilingual')
  end

  test 'first name should be present' do
    @deaf_client.first_name = '     '
    assert_not @deaf_client.valid?
  end

  test 'first name should not be too long' do
    @deaf_client.first_name = 'a' * 51
    assert_not @deaf_client.valid?
  end

  test 'last name should be present' do
    @deaf_client.last_name = '     '
    assert_not @deaf_client.valid?
  end

  test 'last name should not be too long' do
    @deaf_client.last_name = 'a' * 51
    assert_not @deaf_client.valid?
  end

  test 'internal notes should not be too long' do
    @deaf_client.internal_notes = 'a' * 2001
    assert_not @deaf_client.valid?
  end

  test 'public notes should not be too long' do
    @deaf_client.public_notes = 'a' * 2001
    assert_not @deaf_client.valid?
  end
end
