# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationMailer, type: :mailer do
  describe 'notify_user_created' do
    let(:user) do
      FactoryBot.create(:user)
    end
    let(:mail) { ApplicationMailer.notify_user_created(user) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Your profile for ORTE has been created')
      expect(mail.to).to eq([user.email])
      expect(mail.from).to eq(['technik@3plusx.de'])
    end

    it 'renders the headers (in production env)' do
      allow(Rails).to receive(:env) { 'production'.inquiry }
      expect(mail.subject).to eq('Your profile for ORTE has been created')
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('Hurray, we have created a profile')
    end
  end

  describe 'notify_admin_user_created' do
    before do
      @group = FactoryBot.create(:group)
      @user = FactoryBot.create(:user, group: @group)
      @group_admin_user = FactoryBot.create(:admin_user, group: @group)

      @admin_group = FactoryBot.create(:group, title: 'Admins')
      @admin_admin_user = FactoryBot.create(:admin_user, group: @admin_group)

      @admin_adresses = [@admin_admin_user.email]
    end

    let(:mail) { ApplicationMailer.notify_admin_user_created(@user, @admin_adresses) }

    xit 'should check double of admin addressses are collected correctly' do
      pending('TODO')
    end

    it 'renders the headers' do
      expect(mail.subject).to eq("[ORTE Admin -- #{Rails.env}] profile created")
      expect(mail.to).to eq([@admin_admin_user.email])
      expect(mail.from).to eq(['technik@3plusx.de'])
    end

    it 'renders the headers (in production env)' do
      allow(Rails).to receive(:env) { 'production'.inquiry }
      expect(mail.subject).to eq('[ORTE Admin] profile created')
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match('A profile has been created at')
    end
  end
end
