require 'rails_helper'

RSpec.describe Availability, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"

  let(:a_person) { build(:person) }

  describe "creation" do
    it "has a valid factory" do
      @availability = build(:availability, person: a_person)
      expect(@availability).to be_valid
    end
  end

  context 'validations' do
    it { should validate_presence_of(:person) }
    it { should validate_presence_of(:status) }
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:end_time) }

    it "requires end_time to be after start_time" do #chronology
      @availability = build(:availability, person: a_person, start_time: Time.current, end_time: 2.minutes.ago)
      expect(@availability).not_to be_valid
    end
  end

  context 'partially_available?' do
    it 'returns false for full availabilities' do
      start_time = Time.now
      end_time = start_time + 2.minutes
      availability = build(:availability, person: a_person, start_time: start_time, end_time: end_time)

      event = create(:event, start_time: start_time, end_time: end_time, status: "Scheduled")
      expect(availability.partially_available?(event)).to eq(false)
    end
  end
end
