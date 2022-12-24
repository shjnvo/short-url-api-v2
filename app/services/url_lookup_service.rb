class UrlLookupService < BaseLookupService
  private

  def fetch_from_db
    ShortUrl.find_by(code: value)&.original_url
  end
end
