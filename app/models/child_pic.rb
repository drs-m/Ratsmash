class ChildPic < ActiveRecord::Base

  mount_uploader :image, ImageUploader
  belongs_to :sender, class_name: "Student"

  def new_url
    "/uploads/child_pics/#{self.id}/#{File.basename(self.image.path)}"
  end

end
