# encoding: utf-8
class PollAnswer < ActiveRecord::Base

    has_many :poll_votes
    belongs_to :poll

end
