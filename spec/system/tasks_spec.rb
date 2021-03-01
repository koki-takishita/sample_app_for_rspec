require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  describe 'ログイン前' do
    let(:task) { create(:task) }
    # 特定のテストのみafter処理をスキップ
    after do |example|
      unless example.metadata[:skip_after]
        expect(page).to have_current_path login_path
      end
    end
    describe 'タスク新規作成' do
      context '新規作成ページへアクセス' do
        it '新規作成ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content 'Login required'
        end
      end
    end
    describe 'タスクの編集' do
      context '編集編集ページへアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_task_path(task) 
          expect(page).to have_content 'Login required'
        end
      end 
    end
    describe 'タスクの削除' do
      context 'root_pathへアクセス' do
        it 'タスクの削除ボタンがみつからない', :skip_after do
          visit root_path
          expect(page).to_not have_selector 'a', text: 'Destroy'
        end
      end
    end
  end
  describe 'ログイン後' do
    let(:user) { create(:user) }
    let(:task) { build(:task, user: user) }
    #let!(:create_task) { create(:task, user: user) }
    let(:ather_user_task) { create(:task, user: ather_user) }
    before do
      sign_in_as user
    end
    describe 'タスク新規作成' do
      after do |example|
        unless example.metadata[:skip_after]
          expect(page).to have_current_path '/tasks'
          visit tasks_path 
          # 更新しようとしたデータが画面上に表示されてない
          expect(page).to_not have_selector 'td', text: task.title
          expect(page).to_not have_selector 'td', text: task.content
       end
      end
      context 'フォームの入力値が正常' do
        it 'タスクの新規作成が成功する', :skip_after do
          click_link 'New task'
          fill_in 'Title', with: task.title
          fill_in 'Content', with: task.content
          click_button 'Create Task'
          expect(page).to have_content 'Task was successfully created.'
          expect(page).to have_selector 'p', text: task.title
          expect(page).to have_selector 'p', text: task.content
          expect(page).to have_current_path task_path(Task.find_by(user_id: task.user_id)) 
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成が失敗する' do
          click_link 'New task'
          fill_in 'Content', with: task.content
          click_button 'Create Task'
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_selector '#task_content', text: task.content
        end
      end
      context '内容が未入力' do
        it 'タスクの新規作成が失敗する' do
          click_link 'New task'
          fill_in 'Title', with: task.title
          click_button 'Create Task'
          expect(page).to have_content "Content can't be blank"
          expect(page).to have_selector "#task_title[value=#{task.title}]"
        end
      end
    end
    describe 'タスクの編集' do
      let!(:task) { create(:task, user: user) }
      let!(:ather_user_task) { create(:task) }
      before do
        click_link 'Task list'
        click_link 'Edit'
      end
      after do |example|
        unless example.metadata[:skip_after]
          expect(page).to have_current_path "/tasks/#{task.id}"
          visit tasks_path 
          expect(page).to_not have_selector 'td', text: 'edit_title' 
          expect(page).to_not have_selector 'td', text: 'edit_content' 
        end
      end
      context 'フォームの入力値が正常' do
        it 'タスクの編集が成功する', :skip_after do
          fill_in 'Title', with: 'edit_title' 
          fill_in 'Content', with: 'edit_content' 
          click_button 'Update Task'
          expect(page).to have_current_path task_path(task)
          expect(page).to have_content "Task was successfully updated."
          expect(page).to have_selector 'p', text: 'edit_title'
          expect(page).to have_selector 'p', text: 'edit_content'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Title', with: nil
          click_button 'Update Task'
          expect(page).to have_content "Title can't be blank"
        end
      end
      context '内容が未入力' do
        it 'タスクの編集が失敗する' do
          fill_in 'Content', with: nil
          click_button 'Update Task'
          expect(page).to have_content "Content can't be blank"
        end
      end
      context 'ほかユーザーの編集ページにアクセス' do
        it 'タスクの編集ページへのアクセスが失敗する', :skip_after do
          visit edit_task_path(ather_user_task)
          expect(page).to have_content 'Forbidden access.'
          expect(page).to have_current_path root_path
        end
      end
    end
    describe 'タスクの削除' do
      let!(:task) { create(:task, user: user) }
      context 'タスク消去処理 ajaxではない' do
        it 'タスクの削除が成功する' do
          visit root_path
          click_link 'Destroy'
          page.accept_confirm 'Are you sure?'
          expect(page).to have_content 'Task was successfully destroyed.'
          expect(page).to have_current_path '/tasks' 
          expect(page).to_not have_selector 'td', text: task.title
          expect(page).to_not have_selector 'td', text: task.content
        end
      end
    end
  end
end