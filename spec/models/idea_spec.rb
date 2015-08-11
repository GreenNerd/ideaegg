# == Schema Information
#
# Table name: ideas
#
#  id              :integer          not null, primary key
#  title           :string(255)
#  content         :text
#  public          :boolean          default(TRUE)
#  user_id         :integer
#  created_at      :datetime
#  updated_at      :datetime
#  deleted_at      :datetime
#  comments_count  :integer          default(0)
#  visits_count    :integer          default(0)
#  cached_votes_up :integer          default(0)
#  stars_count     :integer          default(0)
#  level           :integer          default(0)
#

require 'rails_helper'

describe Idea do
  describe 'Associations' do
    it { should belong_to :author }
  end

  describe 'Validations' do
    it { should validate_presence_of :title }
    it { should validate_presence_of :content }

    it { should ensure_length_of(:title).is_at_most(140) }

    it 'tags count max is 30' do
      idea = create :idea
      31.times do |x|
        idea.tag_list.add(x.to_s)
      end
      idea.save
      expect(idea.valid?).to be_falsey
    end
  end

  describe 'saving' do
    let(:idea) { create :idea, content: '**World**', summary: nil }

    it 'set default summary' do
      expect(idea.summary.to_s).to eq "World\n"
    end
  end
end
