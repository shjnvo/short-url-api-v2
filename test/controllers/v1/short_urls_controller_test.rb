require 'test_helper'

class V1::ShortUrlsControllerTest < ActionDispatch::IntegrationTest
  teardown do
    Rails.cache.clear
  end

  test 'POST v1/encode' do
    post('/v1/encode', params: { url: 'https://exmaple.com/abc/xyz' })
    assert_response :created
    body = JSON.parse(response.body)
    short_url = ShortUrl.first
    assert_equal short_url.link, body['short_url']
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

  test 'POST v1/encode do not store same URL' do
    post('/v1/encode', params: { url: 'https://exmaple.com/abc/xyz' })
    assert_response :created
    body = JSON.parse(response.body)
    short_url = ShortUrl.first
    assert_equal short_url.link, body['short_url']
    assert_equal 1, ShortUrl.count

    post('/v1/encode', params: { url: 'https://exmaple.com/abc/xyz' })
    assert_response :created

    assert_equal short_url.link, body['short_url']
    assert_equal 1, ShortUrl.count
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

  test 'GET v1/decode read from Cache' do
    url = 'https://exmaple.com/abc/xyz'
    code = 'bbbb123'

    cache_service = CacheService.new(code)
    cache_service.write(url)

    get("/v1/#{code}")

    assert_equal url, cache_service.read

    assert_response :ok
    body = JSON.parse(response.body)

    assert_equal url, body['original_url']
  end

  test 'GET v1/decode with UrlLookupService#call is nil' do
    code = 'abcd123'

    mock = Minitest::Mock.new
    mock.expect :call, nil
    UrlLookupService.stub :new, mock do
      code
    end

    get("/v1/#{code}")

    assert_response :not_found
    body = JSON.parse(response.body)

    assert_equal 'Not found URL !!!', body['message']
  end

  test 'GET /:code reditect to original url' do
    short_url = ShortUrl.create!(original_url: 'https://exmaple.com/abc/xyz', code: 'xxxx1234')

    get("/#{short_url.code}")

    assert_response :found
  end

  test 'GET /:code reder error with wrong code' do
    ShortUrl.create!(original_url: 'https://exmaple.com/abc/xyz', code: 'xxxx1234')

    get("/wrong_code")

    assert_response :ok

    body = response.body

    assert_equal 'Error: Unable to find URL to redirect to.', body
  end
end
