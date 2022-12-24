class CacheService
  CACHE_PREFIX = 'url::'.freeze
  CACHE_DURATION = 1.hour

  def initialize(key)
    @key = key
  end

  def read
    Rails.cache.read(cache_key)
  end

  def write(cache_string)
    Rails.cache.write(cache_key, cache_string, expires_in: CACHE_DURATION) if cache_string.present?
  end

  def delete
    Rails.cache.delete(cache_key)
  end

  private

  attr_reader :key

  def cache_key
    "#{CACHE_PREFIX}#{key}"
  end
end
