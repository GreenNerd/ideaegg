json.(idea, :id, :title, :cover, :summary, :content, :content_html, :stars_count, :comments_count)
json.votes_count idea.cached_votes_up

json.author do
  json.(idea.author, :id, :username, :email, :fullname, :created_at, :phone_number, :avatar)
end

json.tags do
  json.array! idea.tags do |tag|
    json.(tag, :id, :name, :taggings_count)
  end
end
