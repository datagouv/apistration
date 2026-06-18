# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'sitemap.yml' do # rubocop:disable RSpec/DescribeClass
  let(:sitemap) { YAML.load_file(Rails.root.join('config/sitemap.yml')) }

  hosts = {
    'api_entreprise' => 'entreprise.api.localtest.me',
    'api_particulier' => 'particulier.api.localtest.me'
  }

  hosts.each do |ns, host|
    describe ns do
      it 'every path is a valid GET route' do
        invalid = sitemap.fetch(ns).flat_map { |section| section['pages'] }.filter_map do |page|
          url = "http://#{host}#{page['path']}"
          Rails.application.routes.recognize_path(url, method: :get)
          nil
        rescue ActionController::RoutingError
          page['path']
        end

        expect(invalid).to be_empty,
          "Unknown routes in config/sitemap.yml [#{ns}]:\n#{invalid.map { |p| "  #{p}" }.join("\n")}"
      end
    end
  end
end
