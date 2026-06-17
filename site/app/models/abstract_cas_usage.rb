class AbstractCasUsage
  include ActiveModel::Model
  include AbstractAPIClass
  include ExternalUrlHelper

  ATTRIBUTES = %i[
    uid
    name
    introduction
    role
    user_types
    content_category
    use_case_examples
    list_api
    users
    request_access
    legal_context
  ].freeze

  attr_accessor(*ATTRIBUTES)

  def self.all
    backend.map do |uid, entry|
      build_from_yaml(uid, entry)
    end
  end

  def self.find(uid)
    cas_usage = all.find { |item| item.uid == uid }

    raise not_found(uid) if cas_usage.nil?

    cas_usage
  end

  def datapass_url
    ERB.new(request_access[:link_datapass]).result(binding)
  end

  def self.not_found(uid)
    ActiveRecord::RecordNotFound.new("CasUsage '#{uid}' does not exist")
  end

  def self.build_from_yaml(uid, entry)
    new(
      entry.slice(
        *ATTRIBUTES
      ).merge(
        uid: uid.to_s
      ).merge(
        entry.slice(
          *extra_attributes
        )
      )
    )
  end

  def self.extra_attributes
    {}
  end

  def self.backend
    I18n.t("#{api}.cas_usages_entries", raise: true)
  end
end
