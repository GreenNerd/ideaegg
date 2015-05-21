class AddCoverAndSummaryIntoIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :cover, :string
    add_column :ideas, :summary, :text
    add_column :ideas, :content_html, :text
  end
end
