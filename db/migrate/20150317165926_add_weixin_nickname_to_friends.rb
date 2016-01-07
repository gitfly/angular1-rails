class AddWeixinNicknameToFriends < ActiveRecord::Migration
  def change
    add_column :friends, :weixin_nickname, :string
  end
end
