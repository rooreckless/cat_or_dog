require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module CatOrDog
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.
    #
    #以下は「rails gコマンド」使用時にhelperやcoffee,stylesheetが作成されるのを防ぎます。
    # 参考 https://qiita.com/MitsuguSueyoshi/items/b3223e6b05d0d846b4f0
    config.generators do |g|
      g.helper false
      g.assets false
    end
  end
end
