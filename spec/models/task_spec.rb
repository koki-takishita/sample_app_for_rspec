require 'rails_helper'

RSpec.describe Task, type: :model do
  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is calid with a first name, last name, email, and password"
  # 名がなければ無効な状態であること
  it "is invalid without a first name"
  # 姓がなければ無効な状態であること
  it "is invalid without a last name"
  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address"
  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address"
  # ユーザーのフルネームを文字列をして返すこと
  it "returns a user's full name as a string"
end
