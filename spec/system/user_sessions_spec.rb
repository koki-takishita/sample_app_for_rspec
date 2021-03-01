# spec/rails_helper読み込み→raile_helper内Dir[Rails.root.join~~ spec/support以下読み込み
require 'rails_helper'

RSpec.feature "UserSessions", type: :system do
  after do |example|
      unless example.metadata[:skip_after]
        expect(page).to have_current_path root_path
      end
  end
  describe 'ログイン前' do
    let(:user) { create(:user)}
    context 'フォームの入力値が正常' do
      it 'ログイン処理が成功する' do
        sign_in_as user
        expect(page).to have_content 'Login successful'
      end
    end
    context 'フォームが未入力' do
      it 'ログイン処理が失敗する', :skip_after do
        visit login_path
        click_button 'Login'
        expect(page).to have_content 'Login failed'
        expect(page).to have_current_path login_path
      end
    end
  end
  describe 'ログイン後' do
    let(:logged_in_user) { create(:user) }
    
    before do
      sign_in_as logged_in_user
    end

    context 'ログアウトボタンをクリック' do
      it 'ログアウト処理が成功する' do
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
      end
    end
  end
end
