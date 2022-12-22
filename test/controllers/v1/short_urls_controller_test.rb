require 'test_helper'

class V1::ShortUrlsControllerTest < ActionDispatch::IntegrationTest
  test 'POST v1/encode' do
    post('/v1/encode', params: { url: 'https://exmaple.com/abc/xyz' })
    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal '', body['short_url']
  end

  test 'POST v1/decode' do
    post('/v1/decode', params: { code: 'xxxx1234' })
    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal '', body['original_url']
  end
end
