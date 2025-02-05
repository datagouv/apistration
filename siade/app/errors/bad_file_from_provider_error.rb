class BadFileFromProviderError < ApplicationError
  KIND_TO_SUBCODE = {
    invalid_base64: {
      subcode: '051',
      default_detail: 'Erreur lors du décodage : la chaîne de caractères en base64 est invalide'
    },
    timeout_error: {
      subcode: '052',
      default_detail: 'Temps d\'attente de téléchargement du document écoulé'
    },
    http_error: {
      subcode: '053',
      default_detail: 'Erreur de connexion sur le server distant'
    },
    invalid_url: {
      subcode: '054',
      default_detail: 'L\'URL vers le document renvoyée par le fournisseur de données est invalide'
    },
    invalid_extension: {
      subcode: '055',
      default_detail: 'Le fichier n\'est pas au format attendu'
    },
    empty_file: {
      subcode: '056',
      default_detail: 'Le fichier renvoyé par le fournisseur de données est vide'
    }
  }.freeze

  def initialize(provider_name, kind, message = nil)
    @provider_name = provider_name
    @kind = kind.to_sym
    @message = message

    verify_valid_kind!
  end

  def code
    @code = "#{errors_backend.provider_code_from_name(@provider_name)}#{subcode}"
  end

  def title
    'Fichier renvoyé par le fournisseur de données non valide'
  end

  def detail
    @message || subcode_attributes[:default_detail]
  end

  def kind
    :provider_error
  end

  protected

  def subcode
    subcode_attributes[:subcode]
  end

  def subcode_attributes
    @subcode_attributes ||= KIND_TO_SUBCODE.fetch(@kind) do
      raise KeyError, "#{@kind} is not a valid kind name"
    end
  end

  private

  def verify_valid_kind!
    subcode_attributes
  end
end
