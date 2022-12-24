class BaseLookupService
  def initialize(value)
    @value = value
  end

  def call
    (cache_service.read || fetch_from_db).tap do |result|
      cache_service.write(result)
    end
  end

  private

  attr_reader :value

  def cache_service
    @cache_service ||= CacheService.new(value)
  end
end
