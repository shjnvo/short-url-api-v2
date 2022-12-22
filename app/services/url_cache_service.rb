class UrlCacheService
  CACHE_PREFIX = 'url::'.freeze
  CACHE_DURATION = 1.hour

  def initialize(code)
    @code = code
  end

  def read
    Rails.cache.read(cache_key)
  end

  def write(original_url)
    Rails.cache.write(cache_key, original_url, expires_in: CACHE_DURATION) if original_url.present?
  end

  def delete
    Rails.cache.delete(cache_key)
  end

  private

  attr_reader :code

  def cache_key
    "#{CACHE_PREFIX}#{code}"
  end
end
