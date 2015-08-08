class ResetStarsCountOfIdeas < ActiveRecord::Migration
  def up
    Idea.find_each do |idea|
      Idea.reset_counters idea.id, :stars
    end
  end
end
