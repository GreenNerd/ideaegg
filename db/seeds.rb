#user
5.times do
  FactoryGirl.create :user
end

#idea
5.times do
  FactoryGirl.create :idea, user_id: User.first.id
end

#vote and vote
User.find_each do |user|
  user.likes Idea.first
  user.likes Idea.last
  Idea.first.starred_by! user
  Idea.last.starred_by! user
end

#tag and comment
Idea.find_each do |idea|
  idea.tag_list.add("test_tag1", "test_tag2")
  idea.save
  Comment.build_from(idea, User.first.id, Forgery('lorem_ipsum').sentence).save
end
