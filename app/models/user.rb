class User < ActiveRecord::Base
  has_many :words
  include ActiveModel::MassAssignmentSecurity
  attr_protected :uid, :provider, :name
  def self.create_with_omniauth(auth)
    user = User.new
    user.provider = auth['provider']
    user.uid = auth['uid']
    user.name = auth['info']['name']
    user.save
    return user
  end
end
