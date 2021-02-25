require 'rails_helper'

RSpec.feature "Users", type: :feature do
  let(:user) { create(:user) }
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          visit root_path
          click_link 'SignUp'
          #byebug
          fill_in 'Email', with: user.email
          fill_in 'Password', with: user.password
          fill_in 'Password confirmation', with: user.password
          click_button 'SignUp'
          #expect(response).to redirect_to 'login_path'
          #save_and_open_page
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する'
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する'
      end
    end
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する'
      end
    end
  end
  describe 'ログイン後' do
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する'
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する'
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの編集が失敗する'
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する'
      end
    end
    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される'
      end
    end
  end
end
