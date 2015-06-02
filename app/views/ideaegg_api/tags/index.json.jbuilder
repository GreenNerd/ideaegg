json.array! @tags do |tag|
  json.(tag, :id, :name, :taggings_count)
end

