# frozen_string_literal: true

require 'rubocop'
require 'rubocop/rspec/support'
require Rails.root.join('config/rubocop/lazy_lookup_in_shared_handler')

RSpec.describe RuboCop::Cop::Custom::LazyLookupInSharedHandler, :config do
  include RuboCop::RSpec::ExpectOffense

  let(:ruby_version) { 3.4 }
  let(:controller_file) { '/app/app/controllers/api_particulier/blog_posts_controller.rb' }

  it 'flags a lazy lookup in a base controller, which runs for every action of its subclasses' do
    expect_offense(<<~RUBY, '/app/app/controllers/api_particulier_controller.rb')
      def error_title = t('.error.title')
                        ^^^^^^^^^^^^^^^^^ Use an absolute i18n key: [...]
    RUBY
  end

  it 'flags a lazy lookup in a base mailer, which runs for every mailer inheriting it' do
    expect_offense(<<~RUBY, '/app/app/mailers/api_particulier_mailer.rb')
      def subject_line = self.t(:'.subject')
                         ^^^^^^^^^^^^^^^^^^^ Use an absolute i18n key: [...]
    RUBY
  end

  it 'flags a lazy lookup in a rescue_from block, a lambda or a method passed to with:' do
    expect_offense(<<~RUBY, controller_file)
      rescue_from ActiveRecord::RecordNotFound do
        t(".error.\#{kind}")
        ^^^^^^^^^^^^^^^^^^^ Use an absolute i18n key: [...]
      end
      rescue_from Pundit::NotAuthorizedError, with: -> { t('.unauthorized') }
                                                         ^^^^^^^^^^^^^^^^^^ Use an absolute i18n key: [...]
      rescue_from ActionController::BadRequest, with: :bad_request

      def bad_request = t('.bad_request')
                        ^^^^^^^^^^^^^^^^^ Use an absolute i18n key: [...]
    RUBY
  end

  it 'accepts a lazy lookup in an action, which resolves against that action' do
    expect_no_offenses(<<~RUBY, controller_file)
      def show = t('.title')
    RUBY
  end

  it 'accepts absolute keys and I18n.t, which is never lazy, in shared handlers' do
    expect_no_offenses(<<~RUBY, '/app/app/controllers/application_controller.rb')
      rescue_from ActiveRecord::RecordNotFound do
        t('application_controller.error.record_not_found')
        I18n.t('.record_not_found', scope: 'application_controller.error')
      end
    RUBY
  end

  it 'accepts a lazy lookup in a helper, which resolves against the rendering template' do
    expect_no_offenses(<<~RUBY, '/app/app/helpers/application_helper.rb')
      def title = t('.title')
    RUBY
  end
end
