class V1::ShortUrlsController < ApplicationController
  def encode
    short_url = ShortUrl.new(original_url: url_params[:url])
    UrlBuilder.new(short_url).build

    if short_url.exist_url? || short_url.save
      render json: { short_url: short_url.link }, status: :created
    else
      render json: { message: I18n.t('short_url.errors.encode.unprocessable_entity') }, status: :unprocessable_entity
    end
  end

  def decode
    original_url = UrlLookupService.new(code_params[:code]).call

    if original_url
      render json: { original_url: original_url }, status: :ok
    else
      render json: { message: I18n.t('short_url.errors.decode.no_found') }, status: :not_found
    end
  end

  private

  def url_params
    params.permit(:url)
  end

  def code_params
    params.permit(:code)
  end
end
