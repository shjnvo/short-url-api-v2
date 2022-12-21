require 'public_suffix'

class UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    record.errors.add(attribute, options[:message] || 'must be a valid URL') unless url_valid?(value)
  end

  def url_valid?(url)
    url = URI.parse(url)
    valid_scheme = url.is_a?(URI::HTTP) || url.is_a?(URI::HTTPS)
    valid_host = PublicSuffix.valid?(url.host)
    valid_scheme && valid_host
  rescue URI::InvalidURIError
    false
  end
end
