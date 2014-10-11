# encoding: utf-8
class PollVote < ActiveRecord::Base

    belongs_to :poll_answer

end
