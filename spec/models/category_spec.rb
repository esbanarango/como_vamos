require 'rails_helper'

RSpec.describe Category, :type => :model do
  it { expect have_many(:problems)}
  it { expect have_many(:categorizations)}

  describe "validations" do
    it { expect validate_uniqueness_of(:name) }
    it { expect validate_presence_of(:name) }
  end

  it "has friendy id" do
    category = Category.create(name: 'dynamic programming')
    expect(Category.friendly.find('dynamic-programming')).to eql(category)
  end
end
