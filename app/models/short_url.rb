class ShortUrl < ApplicationRecord
  include Codeable

  HOST = 'http://localhost:3000'

  validates :original_url, :code, presence: true
  validates :code, uniqueness: { case_sensitive: true }

  before_validation :assign_code

  private

  def assign_code
    generate_code(:code, 6) unless self.code
    self.code
  end
end
