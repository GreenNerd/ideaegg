json.(idea, :id, :title, :cover, :summary, :content, :content_html, :comments_count)
json.stars_count idea.stars_count
json.votes_count idea.cached_votes_up

json.starred @user.starred?(idea)
json.voted @user.liked?(idea)

json.author do
  json.(idea.author, :id, :username, :email, :fullname, :created_at, :phone_number, :avatar)
end

json.tags do
  json.array! idea.tags do |tag|
    json.(tag, :id, :name, :taggings_count)
  end
end
