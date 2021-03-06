# frozen_string_literal: true

require 'spec_helper'

describe ChangelogValidator::Vcs, :vcr do
  # Check Vcs creates an OctoKit client
  before(:each) do
    pull_request = { 'base' => { 'ref' => 'master', 'repo' => { 'default_branch' => 'master', 'full_name' => 'Xorima/xor_test_cookbook' } },
                     'head' => { 'sha' => '202ae3fd1b76a28c9272372a29ae9b8070a79f48' },
                     'number' => 22 }
    @client = ChangelogValidator::Vcs.new({
                                            token: ENV['GITHUB_TOKEN'] || 'temp_token',
                                            pull_request: pull_request
                                          })
  end

  it 'creates an octkit client' do
    expect(@client).to be_kind_of(ChangelogValidator::Vcs)
  end

  it 'returns true if the pull request is against the default branch' do
    expect(@client.default_branch_target?).to eq true
  end

  it 'creates a pending status check' do
    expect(@client.status_check(state: 'pending')[:state]).to eq 'pending'
  end

  it 'creates a failed status check' do
    expect(@client.status_check(state: 'failure')[:state]).to eq 'failure'
  end

  it 'creates a sucessful status check' do
    expect(@client.status_check(state: 'success')[:state]).to eq 'success'
  end

  it 'Checks the changelog has ## Unreleased' do
    cl = @client.changelog_unreleased_entry?
    expect(cl).to eq false
  end
end
