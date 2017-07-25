require 'test_helper'

class InterpretingRequestTest < ActiveSupport::TestCase
  
  def setup
    @interpreting_request = InterpretingRequest.new(user_id: 1, job_id: 2)
  end

  test 'should be valid' do
    assert @interpreting_request.valid?
  end

  test 'should require a user_id' do
    @interpreting_request.user_id = nil
    assert_not @interpreting_request.valid?
  end

  test 'should require a job_id' do
    @interpreting_request.job_id = nil
    assert_not @interpreting_request.valid?
  end
end
