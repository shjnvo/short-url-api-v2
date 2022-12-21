class ShortUrl < ApplicationRecord
  include Codeable

  HOST = 'http://localhost:3000'

  validates :original_url, presence: true
  validates :code, presence: true
  validates :original_url, url: true
  validates :code, uniqueness: { case_sensitive: true }

  def assign_code
    generate_code(:code, 6) unless code
    code
  end
end
