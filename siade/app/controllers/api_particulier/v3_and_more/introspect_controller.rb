class APIParticulier::V3AndMore::IntrospectController < APIController
  include IntrospectsToken
  include ErrorsNomenclatureDeclaration

  nomenclature_undocumented!
end
