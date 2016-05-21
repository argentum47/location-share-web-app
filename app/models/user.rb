# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string(255)      default(""), not null
#  encrypted_password     :string(255)      default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  confirmation_token     :string(255)
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable, :confirmable

  has_many :location_users
  has_many :locations, through: :location_users

  before_save :set_username_if_empty

  def viewable_locations(id)
    locations.where(location_users: { is_public: true })
  end

  private

  def set_username_if_empty
    unless username.present?
      self.username = email.split("@").first
    end
  end

end
