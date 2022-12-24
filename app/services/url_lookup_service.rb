class UrlLookupService < BaseLookupService
  def call
    (cache_service.read || fetch_from_db).tap do |url|
      cache_service.write(url)
    end
  end

  private

  def fetch_from_db
    ShortUrl.find_by(code: value)&.original_url
  end
end
