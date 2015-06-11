json.array! @comments do |comment|
  json.(comment, :id, :body, :body_html, :created_at)
  json.idea_id comment.commentable_id
  json.user do
    json.(comment.user, :id, :username, :email, :fullname, :created_at, :phone_number, :avatar)
  end
end