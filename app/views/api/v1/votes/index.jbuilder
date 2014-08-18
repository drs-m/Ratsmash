json.array! @votes do |vote|
    json.extract! vote, :rating
    json.category vote.category.name
    json.voter vote.voter.name
    json.voted vote.voted.name
end
