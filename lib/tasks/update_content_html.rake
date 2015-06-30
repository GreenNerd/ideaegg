namespace :ideaegg do
  desc "Update all ideas' content_html"
  task update_content_html: :environment do
    Idea.find_each do |idea|
      idea.summary = idea.content.gsub(/<.*?>/, '').truncate(100,separator: /，|。|,|\./, omission: '') unless idea.summary?
      idea.save
    end
  end
end
