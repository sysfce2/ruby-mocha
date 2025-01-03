# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)

class ExceptionRescueTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_unexpected_invocation_exception_is_not_caught_by_standard_rescue
    test_result = run_as_test do
      mock = mock('mock')
      begin
        mock.some_method
      rescue StandardError => e
        flunk "should not rescue #{e.class}"
      end
    end
    assert_failed(test_result)
    assert_equal 'unexpected invocation: #<Mock:mock>.some_method()', test_result.failure_message_lines[0]
  end

  def test_invocation_never_expected_exception_is_not_caught_by_standard_rescue
    test_result = run_as_test do
      mock = mock('mock')
      mock.expects(:some_method).never
      begin
        mock.some_method
      rescue StandardError => e
        flunk "should not rescue #{e.class}"
      end
    end
    assert_failed(test_result)
    assert_equal 'unexpected invocation: #<Mock:mock>.some_method()', test_result.failure_message_lines[0]
  end
end
