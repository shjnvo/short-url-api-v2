class ShortUrl < ApplicationRecord
  HOST = ENV['HOST']

  validates :original_url, presence: true
  validates :code, presence: true
  validates :original_url, url: true
  validates :code, uniqueness: { case_sensitive: true }

  def link
    "#{ShortUrl::HOST}/v1/#{code}"
  end
end
