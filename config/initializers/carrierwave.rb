# frozen_string_literal: true

CarrierWave.configure do |config|
  config.asset_host = Settings.url
end
