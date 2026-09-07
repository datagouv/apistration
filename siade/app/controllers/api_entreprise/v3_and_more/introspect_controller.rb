class APIEntreprise::V3AndMore::IntrospectController < APIEntrepriseController
  skip_before_action :context_is_filled!

  include IntrospectsToken
  include ErrorsNomenclatureDeclaration

  nomenclature_undocumented!
end
