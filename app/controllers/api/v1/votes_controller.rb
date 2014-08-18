# encoding: utf-8
module API
module V1
class VotesController < ApplicationController

    def index
        @votes = Vote.all.limit(2000)
    end

end
end
end
