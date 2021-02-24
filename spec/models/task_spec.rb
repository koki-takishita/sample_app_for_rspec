require 'rails_helper'

RSpec.describe Task, type: :model do
  describe 'validation' do
    # すべての属性があれば有効な状態であること
    it 'is valid with all attributes' do
      task = build(:task)
      expect(task).to be_valid
      expect(task.errors).to be_empty
    end
    # タイトルがなければ無効な状態であること
    it 'is invalid without a title' do
      without_title_task = build(:task, title: nil)
      expect(without_title_task).to be_invalid
      expect(without_title_task.errors[:title]).to include("can't be blank")
    end
    # ステータスがなければ無効な状態であること
    it 'is invalid without a status' do
      without_status_task = build(:task, status: nil)
      expect(without_status_task).to be_invalid
      expect(without_status_task.errors[:status]).to include("can't be blank")
    end
    # タイトルが重複していると無効な状態であること
    it 'is invalid with a duplicate title' do
      task = create(:task)
      task2 = build(:task, title: task.title)
      expect(task2).to be_invalid
      expect(task2.errors[:title]).to include('has already been taken')
    end
    # タイトルを別の名前にすれば、有効な状態であること
    it 'is valid with another title' do
      task = create(:task)
      task_with_another_title = build(:task, title: 'another_title')
      expect(task_with_another_title).to be_valid
      expect(task_with_another_title.errors).to be_empty
    end
  end
end
