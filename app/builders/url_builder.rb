class UrlBuilder
  delegate :code, to: :url

  def initialize(url)
    @url = url
  end

  def build
    url.code = build_shortened
  end

  private

  attr_reader :url

  def build_shortened
    real_time << 7

    IntToBase64.encode(real_time)
  end

  def real_time
    Process.clock_gettime(Process::CLOCK_REALTIME, :millisecond)
  end
end
