# frozen_string_literal: true

require 'test_helper'

class AssignsControllerControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get assigns_controller_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get assigns_controller_destroy_url
    assert_response :success
  end
end
