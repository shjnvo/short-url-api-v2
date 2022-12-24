class ShortUrl < ApplicationRecord
  HOST = ENV['HOST']

  validates :original_url, presence: true
  validates :code, presence: true
  validates :original_url, url: true
  validates :code, uniqueness: { case_sensitive: true }

  def link
    "#{ShortUrl::HOST}/#{code}"
  end

  def exist_url?
    exist_code = CodeLookupService.new(original_url).call
    self.code = exist_code if exist_code
  end
end
