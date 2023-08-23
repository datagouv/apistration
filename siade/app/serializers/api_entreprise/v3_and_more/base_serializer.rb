class APIEntreprise::V3AndMore::BaseSerializer
  attr_reader :data, :context

  def initialize(payload_data)
    @data = payload_data.data
    @context = payload_data.context
  end

  class << self
    attr_accessor :__attributes, :__links, :__meta

    def attributes(*attrs)
      self.__attributes ||= {}

      attrs.each do |attr|
        self.__attributes[attr] = lambda { |resource|
          resource.public_send(attr)
        }
      end
    end

    def attribute(attr, &block)
      self.__attributes ||= {}
      self.__attributes[attr] = block
    end

    def link(attr, &block)
      self.__links ||= {}
      self.__links[attr] = block
    end

    def meta(&block)
      self.__meta = block
    end

    def url_for(params = {})
      host = Rails.env.production? ? 'entreprise.api.gouv.fr' : "#{Rails.env}.entreprise.api.gouv.fr"

      Rails.application.routes.url_helpers.url_for(params.merge(host:))
    end

    def url_for_proxied_file(url)
      url_for(
        controller: 'api_entreprise/proxied_files',
        action: :show,
        uuid: ProxiedFileService.set(url)
      )
    rescue ProxiedFileService::ConnectionError
      url
    end
  end

  def serializable_hash
    serialize_single_resource
  end

  private

  def serialize_single_resource
    serialize_model(data)
  end

  def serialize_model(model)
    {
      data: compute_attributes(:__attributes, model),
      links: compute_attributes(:__links, model),
      meta: self.class.__meta.try(:call, model) || {}
    }
  end

  def compute_attributes(kind, model)
    (self.class.public_send(kind) || {}).transform_values do |block|
      block.call(model)
    end
  end
end
