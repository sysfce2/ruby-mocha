# frozen_string_literal: true

require File.expand_path('../acceptance_test_helper', __FILE__)
require 'mocha/configuration'

class StubbingMethodUnnecessarilyTest < Mocha::TestCase
  include AcceptanceTestHelper

  def setup
    setup_acceptance_test
  end

  def teardown
    teardown_acceptance_test
  end

  def test_should_allow_stubbing_method_unnecessarily
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :allow }
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?('stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)')
  end

  def test_should_warn_when_stubbing_method_unnecessarily
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :warn }
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
    assert_passed(test_result)
    assert @logger.warnings.include?('stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)')
  end

  def test_should_prevent_stubbing_method_unnecessarily
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :prevent }
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
    assert_errored(test_result)
    assert test_result.error_messages.include?('Mocha::StubbingError: stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)')
  end

  def test_should_default_to_allow_stubbing_method_unnecessarily
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
    end
    assert_passed(test_result)
    assert !@logger.warnings.include?('stubbing method unnecessarily: #<Mock:mock>.public_method(any_parameters)')
  end

  def test_should_allow_stubbing_method_when_stubbed_method_is_invoked
    Mocha.configure { |c| c.stubbing_method_unnecessarily = :prevent }
    test_result = run_as_test do
      mock = mock('mock')
      mock.stubs(:public_method)
      mock.public_method
    end
    assert_passed(test_result)
  end
end
