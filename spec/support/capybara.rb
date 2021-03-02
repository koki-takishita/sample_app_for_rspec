RSpec.configure do |config|
  config.before(:each, type: :system) do
    # ブラウザの表示の有無を切り替える
    driven_by (:selenium_chrome_headless)
  end
end
