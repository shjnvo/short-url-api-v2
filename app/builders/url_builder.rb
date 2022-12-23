class UrlBuilder
  delegate :code, to: :short_url

  def initialize(short_url)
    @short_url = short_url
  end

  def build
    if fetch_from_db
      fetch_from_db
    else
      short_url.code = build_shortened
      short_url
    end
  end

  private

  attr_accessor :short_url

  def build_shortened
    real_time << 7

    IntToBase64.encode(real_time)
  end

  def real_time
    Process.clock_gettime(Process::CLOCK_REALTIME, :millisecond)
  end

  def fetch_from_db
    ShortUrl.find_by(original_url: short_url.original_url)
  end
end
