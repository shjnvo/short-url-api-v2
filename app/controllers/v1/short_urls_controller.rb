class V1::ShortUrlsController < ApplicationController
  def encode
    render json: { short_url: 'this is decode URL' }
  end

  def decode
    render json: { original_url: 'this is decode URL' }
  end
end
