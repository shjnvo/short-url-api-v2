class CodeLookupService < BaseLookupService

  def call
    (cache_service.read || fetch_from_db).tap do |code|
      cache_service.write(code)
    end
  end

  private

  def fetch_from_db
    ShortUrl.find_by(original_url: value)&.code
  end
end
