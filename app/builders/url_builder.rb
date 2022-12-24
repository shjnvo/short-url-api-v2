class UrlBuilder
  delegate :code, to: :short_url

  def initialize(short_url)
    @short_url = short_url
  end

  def build
    short_url.code = build_shortened
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
end
