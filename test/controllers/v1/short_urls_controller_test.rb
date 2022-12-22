require 'test_helper'

class V1::ShortUrlsControllerTest < ActionDispatch::IntegrationTest
  test 'POST v1/encode' do
    post('/v1/encode', params: { url: 'https://exmaple.com/abc/xyz' })
    assert_response :created
    body = JSON.parse(response.body)
    short_url = ShortUrl.first
    assert_equal "#{V1::ShortUrlsController::HOST}/#{short_url.code}", body['short_url']
  end

  test 'POST v1/encode with url wrong format' do
    post('/v1/encode', params: { url: 'ftps://exmaple.com/abc/xyz' })

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)

    assert_equal 'URL is wrong format !!!', body['message']
  end

  test 'POST v1/encode with code is nil' do
    mock = Minitest::Mock.new
    mock.expect :real_time, 0
    UrlBuilder.stub :new, mock do
      ShortUrl.new(original_url: 'https://exmaple.com/abc/xyz')
    end

    post('/v1/encode', params: { url: 'ftps://exmaple.com/abc/xyz' })

    assert_response :unprocessable_entity
    body = JSON.parse(response.body)

    assert_equal 'URL is wrong format !!!', body['message']
  end

  test 'GET v1/decode' do
    short_url = ShortUrl.create!(original_url: 'https://exmaple.com/abc/xyz', code: 'xxxx1234')
    get("/v1/#{short_url.code}")

    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal short_url.original_url, body['original_url']
  end

  test 'GET v1/decode with wrong code' do
    wrong_code = 'xxxx1234'
    get("/v1/#{wrong_code}")

    assert_response :not_found
    body = JSON.parse(response.body)

    assert_equal 'Not found URL !!!', body['message']
  end
end
