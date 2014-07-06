# encoding: utf-8
class Description < ActiveRecord::Base
    belongs_to :author, class_name: "Student"
    belongs_to :described, class_name: "Student"
	
end