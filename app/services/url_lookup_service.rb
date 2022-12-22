class UrlLookupService
  def initialize(code)
    @code = code
  end

  def call
    (cache_service.read || fetch_from_db).tap do |f_url|
      cache_service.write(f_url)
    end
  end

  private

  attr_reader :code

  def cache_service
    @cache_service ||= UrlCacheService.new(code)
  end

  def fetch_from_db
    ShortUrl.find_by(code: code)&.original_url
  end
end
