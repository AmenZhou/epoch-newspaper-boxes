class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, 
         :recoverable, :rememberable, :trackable, :validatable

  validates_presence_of :epoch_branch_id
  belongs_to :epoch_branch

  def is_admin?
    self.role == 'Admin' ? true : false
  end

  def is_nj?
    epoch_branch.name == 'NJ'
  end

  def is_ny?
    epoch_branch.name == 'NY'
  end
end
