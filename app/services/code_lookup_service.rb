class CodeLookupService < BaseLookupService
  private

  def fetch_from_db
    ShortUrl.find_by(original_url: value)&.code
  end
end
