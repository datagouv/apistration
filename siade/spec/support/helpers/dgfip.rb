def valid_dgfip_user_id
  UserIdDGFIPService.call(yes_jwt_user.id)
end

def valid_dgfip_cookie
  # out of date cookie but valid
  'lemondgfip=8198b3aac665ab0cf0cc5b31c4e7555d_ec5d7dc4d12944a8940b700c34bd2b80; domain=.dgfip.finances.gouv.fr; path=/'
end

def valid_tax_number
  '3999999898230'
end

def valid_tax_notice_number
  '2234567890ABC'
end
