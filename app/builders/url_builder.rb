class UrlBuilder
  STATIC_COUNTER = 100_000_000_000

  delegate :code, :id, to: :short_url

  def initialize(short_url)
    @short_url = short_url
  end

  def build
    short_url.code, short_url.id = build_shortened
  end

  private

  attr_reader :short_url

  def build_shortened
    last_short_url = ShortUrl.last
    encode_number = last_short_url ? last_short_url.id + 1 : STATIC_COUNTER

    [IntToBase62.encode(encode_number), encode_number]
  end
end
