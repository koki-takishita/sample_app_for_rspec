RSpec.configure do |config|
  config.before(:each, type: :system) do
    driven_by :rack_test
  end
  # ブラウザの表示の有無を切り替える
  config.before(:each, type: :system, js: true) do
    driven_by :selenium_chrome_headless
  end
end
