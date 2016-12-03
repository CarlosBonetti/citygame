require 'i18n'

# Where the I18n library should search for translation files
I18n.load_path = Dir['src/config/locales/*.yml']

# Set default locale to something other than :en
I18n.default_locale = :pt
