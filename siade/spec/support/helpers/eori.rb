def valid_eori
  'FR16002307300010' # Centre informatique douanier
end

def valid_spanish_eori
  # from https://www.tibagroup.com/es/en/eori-number-spain
  'ESA08536583' # Tiba Spain SAU
end

def invalid_eori
  'FR012345678901234' # Wrong format (FR + siret in france), added one extra char to be sure
end

def non_existing_eori
  'FR82827787100020' # Saturne consulting, sasu of H.Lepetit, developer. Guaranteed not to have an EORI attached
end
