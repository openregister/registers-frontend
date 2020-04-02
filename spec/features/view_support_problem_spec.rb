# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Support page', type: :feature do
  before do
    visit support_path
  end

  describe 'the initial form' do
    it 'shows an option for government agents' do
      expect(page).to have_content t('support.group.gov')
    end

    it 'shows an option for civil service workers' do
      expect(page).to have_content t('support.group.public')
    end

    it 'checks the member of the public option by default' do
      expect(page).to have_checked_field t('support.group.public')
    end
  end

  describe 'when member of the public' do
    before do
      choose t('support.group.public')
      click_on 'Continue'
    end

    it 'indicates Registers is not the right place' do
      expect(page).to have_content t('support.public.notice')
    end

    it 'displays links to more useful pages' do
      t('support.public.links').each do |text, _, _|
        expect(page).to have_link text
      end
    end
  end

  describe 'when civil service worker' do
    let(:subject) { 'The API is broken' }
    let(:message) { 'I cannot see replies from the API.' }
    let(:name) { 'John Doe' }
    let(:email) { 'john@doe.com' }

    before do
      choose t('support.group.gov')
      click_on 'Continue'
    end

    it 'presents a form' do
      expect(page).to have_selector 'form'
    end

    context 'with valid form data' do
      let(:zendesk_client) { instance_double(ZendeskFeedback) }

      before do
        allow(ZendeskFeedback).to receive(:new).and_return zendesk_client

        fill_in 'Subject', with: subject
        fill_in 'Message', with: message
        fill_in 'Name', with: name
        fill_in 'Email address', with: email
      end

      it 'sends a Zendesk ticket across' do
        expect(zendesk_client)
          .to receive(:send_feedback)
          .with(hash_including(
                  subject: subject,
                  message: message,
                  name: name,
                  email: email
                ))

        click_on 'Submit'
      end
    end
  end

  scenario 'correct information shown after invalid submission' do
    skip 'obsolete'
    expect(page).to have_content('Report a problem')
    click_button('Submit')
    expect(page).to have_content('Report a problem')
  end
end
