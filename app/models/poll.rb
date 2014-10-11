# encoding: utf-8
class Poll < ActiveRecord::Base

    has_many :poll_answers

end
