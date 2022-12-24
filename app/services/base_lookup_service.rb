class BaseLookupService
  def initialize(value)
    @value = value
  end

  def call
    raise NotImplementedError.new("Please Implement method [#{__method__}]")
  end

  private

  attr_reader :value

  def cache_service
    @cache_service ||= CacheService.new(value)
  end
end
