class Post < ActiveRecord::Base
    acts_as_taggable_on :tags
    
    belongs_to :user, dependent: :destroy
    has_many :notifications, dependent: :destroy  
    has_many :comments, dependent: :destroy
    validates :user_id, presence: true
    validates :image, presence: true
    validates :caption, length: { minimum: 3, maximum: 300 }

  has_attached_file :image, styles: { :medium => "640x" }
  validates_attachment_content_type :image, :content_type => /\Aimage\/.*\Z/
end
