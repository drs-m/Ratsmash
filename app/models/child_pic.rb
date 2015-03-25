class ChildPic < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  belongs_to :sender, class_name: "Student"

end
