require 'rails_helper'

RSpec.feature 'admin lists sensors', type: :feature do
  let(:home) do
    FactoryBot.create(:home)
  end
  let(:whanau) do
    user = FactoryBot.create :user
    home.users << user
    user
  end

  subject { page }

  shared_examples 'sensor was deleted' do
    it 'sensor was deleted' do
      is_expected.not_to have_text sensor.node_id
    end
  end

  shared_examples 'can delete sensors' do
    before(:each) do
      visit "/homes/#{sensor.home.id}/sensors"
      click_link 'delete'
    end
    context 'unassigned sensor' do
      let(:sensor) { FactoryBot.create :sensor, home: home, room: nil }
      include_examples 'sensor was deleted'
    end
    context 'assigned sensor' do
      let(:room) { FactoryBot.create :room, home: home }
      let(:sensor) { FactoryBot.create :sensor, home: home, room: room }
      include_examples 'sensor was deleted'
    end
    context 'sensor with messages' do
      let(:sensor) { FactoryBot.create :sensor_with_messages, home: home }
      include_examples 'sensor was deleted'
    end
  end

  context 'signed in as a normal user' do
    background { login_as(home.owner) }
    include_examples 'can delete sensors'
  end

  context 'signed in as admin' do
    background { login_as(FactoryBot.create(:admin)) }
    include_examples 'can delete sensors'
  end

  context 'signed in as whanau' do
    background { login_as(whanau) }
    let(:sensor) { FactoryBot.create :sensor, home: home }
    before { visit "/homes/#{sensor.home.id}/sensors" }
    it { is_expected.not_to have_link 'delete' }
  end
end
