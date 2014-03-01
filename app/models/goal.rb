# == Schema Information
#
# Table name: goals
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  user_id    :integer          not null
#  private    :boolean          not null
#  completed  :boolean          not null
#  created_at :datetime
#  updated_at :datetime
#

class Goal < ActiveRecord::Base
  validates :name, :user, :presence => true
  validates :private, :completed, inclusion: { in: [true, false] }

  belongs_to :user
  before_validation :public_by_default, :incomplete_by_default

  private

    def public_by_default
      self.private ||= false
      true
    end

    def incomplete_by_default
      self.completed ||= false
      true
    end
end
