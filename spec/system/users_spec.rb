require 'rails_helper'

RSpec.feature "Users", type: :system do
  describe 'ログイン前' do
    let(:user) { build(:user) }
    # 登録済みのメールアドレスが必要なため
    let!(:other_user)  { create(:user, email: 'other@co.jp') }
    let(:other_user2)  { build(:user, email: 'other@co.jp') }
    describe 'ユーザー新規登録' do
      before do
        visit root_path 
        click_link 'SignUp'
        fill_in 'Password', with: user.password
        fill_in 'Password confirmation', with: user.password_confirmation
      end
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          fill_in 'Email', with: user.email
          click_button 'SignUp'
          # expect(response).to redirect_to 'login_path'
          expect(page).to have_content 'User was successfully created.'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          click_button 'SignUp'
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'Email', with: other_user2.email
          click_button 'SignUp'
          # save_and_open_page
          # expect(ather_user
          expect(page).to have_content 'Email has already been taken'
        end
      end
    end
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit users_path
          expect(page).to have_content 'Login required' 
        end
      end
    end
  end
  describe 'ログイン後' do
    let(:registered_user) { create(:user) }
    let(:edit_user) { create(:user) }
    let(:new_task) { build(:task) }
    before do
      sign_in_as edit_user
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          visit edit_user_path(edit_user)
          click_button 'Update'
          expect(page).to have_content 'User was successfully updated.' 
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(edit_user) 
          fill_in 'Email', with: ''    
          click_button 'Update'
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済みのメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          visit edit_user_path(edit_user)
          fill_in 'Email', with: registered_user.email
          click_button 'Update'
          expect(page).to have_content 'Email has already been taken'
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(registered_user)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end
    describe 'マイページ' do
      context 'タスクを作成' do
        it '新規作成したタスクが表示される' do
         click_link 'New task'
         fill_in 'Title', with: new_task.title
         fill_in 'Content', with: new_task.content
         select new_task.status, from: 'Status'
         click_button 'Create Task'
         expect(page).to have_content 'Task was successfully created.'
        end
      end
    end
  end
end
