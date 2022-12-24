require 'test_helper'

class ShortUrlTest < ActiveSupport::TestCase
  test "validates the original_url can't be blank" do
    short_url = ShortUrl.new

    assert_not short_url.valid?
    assert_equal ["can't be blank", 'must be a valid URL'], short_url.errors.messages[:original_url]
  end

  test 'validates the original_url accept https' do
    short_url = ShortUrl.new(original_url: 'https://example.com/abc/xyz', code: 'xxxx1234')

    assert short_url.save
  end

  test 'validates the original_url accept http' do
    short_url = ShortUrl.new(original_url: 'http://example.com/abc/xyz', code: 'xxxx1234')

    assert short_url.save
  end

  test 'validates the original_url wrong format' do
    short_url = ShortUrl.new(original_url: 'https://localhost:3000/abc/xyz', code: 'xxxx1234')
    assert_not short_url.valid?
    assert_equal ['must be a valid URL'], short_url.errors.messages[:original_url]

    short_url.original_url = 'ftp://example.com/abc/xyz'
    assert_not short_url.valid?
    assert_equal ['must be a valid URL'], short_url.errors.messages[:original_url]

    short_url.original_url = 'socket://example.com/abc/xyz'
    assert_not short_url.valid?
    assert_equal ['must be a valid URL'], short_url.errors.messages[:original_url]

    short_url.original_url = 'https://example/abc/xyz'
    assert_not short_url.valid?
    assert_equal ['must be a valid URL'], short_url.errors.messages[:original_url]

    short_url.original_url = 'https://example.com/abc/xyz^%'
    assert_not short_url.valid?
    assert_equal ['must be a valid URL'], short_url.errors.messages[:original_url]

    short_url.original_url = 'https://example.com/abc/xyz'
    assert short_url.save
  end

  test "validates the code can't be blank" do
    short_url = ShortUrl.new
    short_url.code = nil

    assert_not short_url.save
    assert_equal ["can't be blank"], short_url.errors.messages[:code]
  end

  test 'validates the code must unique' do
    short_url = ShortUrl.create(original_url: 'https://example.com/abc/xyz', code: 'xxxx1234')
    unvalid_short_url = ShortUrl.new(original_url: 'https://example.com/abc/xyz', code: short_url.code)

    assert_not unvalid_short_url.save
    assert_equal ['has already been taken'], unvalid_short_url.errors.messages[:code]
  end

  test '#link' do
    test_code = 'xxxx123'

    short_url = ShortUrl.new(original_url: 'https://example.com/abc/xyz', code: test_code)

    assert "#{ShortUrl::HOST}/v1/#{test_code}", short_url.link
  end

  test '#exist_url?' do
    short_url = ShortUrl.create(original_url: 'https://example.com/abc/xyz', code: 'xxxx1234')
    duplicate_url = ShortUrl.new(original_url: 'https://example.com/abc/xyz')
    new_url = ShortUrl.new(original_url: 'https://example999.com/abc/xyz')

    assert duplicate_url.exist_url?
    assert_equal short_url.link, duplicate_url.link

    assert_not new_url.exist_url?
  end
end
