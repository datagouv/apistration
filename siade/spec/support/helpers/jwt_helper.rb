module JwtHelper
  class << self
    # rubocop:disable Metrics/MethodLength
    def jwt(type = :valid)
      samples = {
        valid: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiIzZDQ3MDZjNC03ZjVlLTQ0NDItYTczNC0wMGQ2YzY3NWYzYzkiLCJyb2xlcyI6WyJhdHRlc3RhdGlvbnNfYWdlZmlwaCIsImF0dGVzdGF0aW9uc19maXNjYWxlcyIsImF0dGVzdGF0aW9uc19zb2NpYWxlcyIsImNlcnRpZmljYXRfY25ldHAiLCJhc3NvY2lhdGlvbnMiLCJjZXJ0aWZpY2F0X29wcWliaSIsImRvY3VtZW50c19hc3NvY2lhdGlvbiIsImV0YWJsaXNzZW1lbnRzIiwiZW50cmVwcmlzZXMiLCJlbnRyZXByaXNlc19hcnRpc2FuYWxlcyIsImV4dHJhaXRfY291cnRfaW5waSIsImV4dHJhaXRzX3JjcyIsImV4ZXJjaWNlcyIsImxpYXNzZV9maXNjYWxlIiwiZm50cF9jYXJ0ZV9wcm8iLCJxdWFsaWJhdCIsInByb2J0cCIsIm1zYV9jb3Rpc2F0aW9ucyIsImJpbGFuc19lbnRyZXByaXNlX2JkZiIsImNlcnRpZmljYXRfcmdlX2FkZW1lIiwiY2VydGlmaWNhdF9hZ2VuY2VfYmlvIiwiYWN0ZXNfaW5waSIsImJpbGFuc19pbnBpIiwiY29udmVudGlvbnNfY29sbGVjdGl2ZXMiLCJlb3JpX2RvdWFuZXMiXSwic3ViIjoidGVzdCBzaWFkZSIsImlhdCI6MTU5Njc5MTY1OSwidmVyc2lvbiI6IjEuMCJ9.F8iEMbQ5niCGqAU4UZu7JGLDtbAoGVtVmH9m45UCSAM',
        with_scopes_not_roles: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJiYTI2MWY5OC1mMjA0LTQ0ZmYtOGQwYS04MmEzNWEzYjFlYWEiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJzY29wZXMiOlsiZG9jdW1lbnRzX2Fzc29jaWF0aW9uIiwiYXNzb2NpYXRpb25zIiwiZm50cF9jYXJ0ZV9wcm8iLCJlbnRyZXByaXNlX2FydGlzYW5hbGUiLCJ1cHRpbWUiLCJwcm9idHAiLCJhaWRlc19jb3ZpZF9lZmZlY3RpZnMiLCJldGFibGlzc2VtZW50cyIsImNlcnRpZmljYXRfY25ldHAiLCJiaWxhbnNfZW50cmVwcmlzZV9iZGYiLCJjZXJ0aWZpY2F0X3JnZV9hZGVtZSIsImV4dHJhaXRfY291cnRfaW5waSIsImNlcnRpZmljYXRfb3BxaWJpIiwiY29udmVudGlvbnNfY29sbGVjdGl2ZXMiLCJwcml2aWxlZ2VzIiwiYWN0ZXNfaW5waSIsImJpbGFuc19pbnBpIiwiYXR0ZXN0YXRpb25zX3NvY2lhbGVzIiwibXNhX2NvdGlzYXRpb25zIiwicXVhbGliYXQiLCJhdHRlc3RhdGlvbnNfYWdlZmlwaCIsImVudHJlcHJpc2VzIiwiZXh0cmFpdHNfcmNzIiwiZW9yaV9kb3VhbmVzIiwiY2VydGlmaWNhdF9hZ2VuY2VfYmlvIiwiZXh0cmFpdF9yY3MiLCJlbnRyZXByaXNlIiwiZXRhYmxpc3NlbWVudCIsImxpYXNzZV9maXNjYWxlIiwiYXR0ZXN0YXRpb25zX2Zpc2NhbGVzIiwiZXhlcmNpY2VzIiwiZW50cmVwcmlzZXNfYXJ0aXNhbmFsZXMiXSwic3ViIjoidGVzdCBkZXZlbG9wbWVudCIsImlhdCI6MTY1NTcyMzg5NiwidmVyc2lvbiI6IjEuMCJ9.ATyCvTTS-dC8aXT_2TcrtJ_fYUP8VkqjQWjblPojJUo',
        expired: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiIzZDQ3MDZjNC03ZjVlLTQ0NDItYTczNC0wMGQ2YzY3NWYzYzkiLCJyb2xlcyI6WyJhdHRlc3RhdGlvbnNfYWdlZmlwaCIsImF0dGVzdGF0aW9uc19maXNjYWxlcyIsImF0dGVzdGF0aW9uc19zb2NpYWxlcyIsImNlcnRpZmljYXRfY25ldHAiLCJhc3NvY2lhdGlvbnMiLCJjZXJ0aWZpY2F0X29wcWliaSIsImRvY3VtZW50c19hc3NvY2lhdGlvbiIsImV0YWJsaXNzZW1lbnRzIiwiZW50cmVwcmlzZXMiLCJlbnRyZXByaXNlc19hcnRpc2FuYWxlcyIsImV4dHJhaXRfY291cnRfaW5waSIsImV4dHJhaXRzX3JjcyIsImV4ZXJjaWNlcyIsImxpYXNzZV9maXNjYWxlIiwiZm50cF9jYXJ0ZV9wcm8iLCJxdWFsaWJhdCIsInByb2J0cCIsIm1zYV9jb3Rpc2F0aW9ucyIsImJpbGFuc19lbnRyZXByaXNlX2JkZiIsImNlcnRpZmljYXRfcmdlX2FkZW1lIiwiYWN0ZXNfaW5waSIsImJpbGFuc19pbnBpIiwiY29udmVudGlvbnNfY29sbGVjdGl2ZXMiLCJlb3JpX2RvdWFuZXMiXSwic3ViIjoidGVzdCBzaWFkZSIsImlhdCI6MTU5Njc5MTY1OSwiZXhwIjoxNTk2NzkxNjU5LCJ2ZXJzaW9uIjoiMS4wIn0.bZBUgTgb-kK3WHI2BQ6nIaFLTGHi6FH2bgr5GGIX_YA',
        unsigned: 'eyJhbGciOiJub25lIn0.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiIzZDQ3MDZjNC03ZjVlLTQ0NDItYTczNC0wMGQ2YzY3NWYzYzkiLCJyb2xlcyI6WyJhdHRlc3RhdGlvbnNfYWdlZmlwaCIsImF0dGVzdGF0aW9uc19maXNjYWxlcyIsImF0dGVzdGF0aW9uc19zb2NpYWxlcyIsImNlcnRpZmljYXRfY25ldHAiLCJhc3NvY2lhdGlvbnMiLCJjZXJ0aWZpY2F0X29wcWliaSIsImRvY3VtZW50c19hc3NvY2lhdGlvbiIsImV0YWJsaXNzZW1lbnRzIiwiZW50cmVwcmlzZXMiLCJlbnRyZXByaXNlc19hcnRpc2FuYWxlcyIsImV4dHJhaXRfY291cnRfaW5waSIsImV4dHJhaXRzX3JjcyIsImV4ZXJjaWNlcyIsImxpYXNzZV9maXNjYWxlIiwiZm50cF9jYXJ0ZV9wcm8iLCJxdWFsaWJhdCIsInByb2J0cCIsIm1zYV9jb3Rpc2F0aW9ucyIsImJpbGFuc19lbnRyZXByaXNlX2JkZiIsImNlcnRpZmljYXRfcmdlX2FkZW1lIiwiYWN0ZXNfaW5waSIsImJpbGFuc19pbnBpIiwiY29udmVudGlvbnNfY29sbGVjdGl2ZXMiLCJlb3JpX2RvdWFuZXMiXSwic3ViIjoidGVzdCBzaWFkZSIsImlhdCI6MTU5Njc5MTY1OSwidmVyc2lvbiI6IjEuMCJ9.',
        forged: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI0YzYzYzlkOS0xOGRjLTRhNjMtYTU1NS1kZTg3ZjY0M2YyYzAiLCJyb2xlcyI6WyJyb2wzIiwicm9sNCJdfQ.28Zo8dOMOxd4G5-nR-sfmNlbqRnSvbRbVkVto6i50gI',
        corrupted: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI0YzYzYzlkOS0xOGRjLTRhNjMtYTU1NSgdfgd1kZTg3ZjY0M2YyYzAiLCJyb2xlcyI6WyJyb2wzIiwicm9sNCJdfQ.28Zo8dOMOxd4G5-nR-sfmNlbqRnSvbRbVkVto6i50gI',
        no_roles: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiJiMTU3OGRhMC01MmZlLTRiY2EtYmZhYy1iNWUxODNlOWU3MWMiLCJyb2xlcyI6W10sInN1YiI6Ik5PIEpXVCIsImlhdCI6MTU4MDMwMzEyMCwidmVyc2lvbiI6IjEuMCJ9._ZpUKwrIJrIl4KYkF17FZT79tGFG9-yo7GFcpQIUbBk',
        without_uuid_as_jti: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiJpbnZhbGlkIiwicm9sZXMiOlsid2hhdGV2ZXIiXSwic3ViIjoidGVzdCBzaWFkZSIsImlhdCI6MTU5Njc5MTY1OSwidmVyc2lvbiI6IjEuMCJ9.09_hJkhzetsWqVtRbVKtUfKdc4JsXmhpo3msX6Izn4M',
        without_uuid_as_uid: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJpbnZhbGlkIiwianRpIjoiM2Q0NzA2YzQtN2Y1ZS00NDQyLWE3MzQtMDBkNmM2NzVmM2M5Iiwicm9sZXMiOlsid2hhdGV2ZXIiXSwic3ViIjoidGVzdCBzaWFkZSIsImlhdCI6MTU5Njc5MTY1OSwidmVyc2lvbiI6IjEuMCJ9.9PSixIaih7miBAFI39EY2Gw_eedZeAe8bo9drzhPD_U',
        uptime: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI3M2FmYTU0ZS04YzkxLTQ2NjctYmQyYS0xMDFhOGI4NjUxMjgiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJyb2xlcyI6WyJ1cHRpbWUiXSwic3ViIjoidGVzdCBkZXZlbG9wbWVudCIsImlhdCI6MTY1MTIzNjE2OSwidmVyc2lvbiI6IjEuMCJ9.aht7DqgzoLtoBd4URiXP2W4COg4hbo5Lrzs7JlRhHYk'
      }

      samples[type]
    end

    # XXX Review me, could cause a decorrelation later on if left like this. Trying
    # to compensate the lack of vision one can have with the tests since it is
    # encrypted and not very readable
    def values_for_valid_jwt
      {
        id: 'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4',
        jti: '3d4706c4-7f5e-4442-a734-00d6c675f3c9',
        roles: %w[
          attestations_agefiph
          attestations_fiscales
          attestations_sociales
          certificat_cnetp
          associations
          conventions_collectives
          certificat_opqibi
          certificat_agence_bio
          documents_association
          etablissements
          entreprises
          entreprises_artisanales
          extrait_court_inpi
          extraits_rcs
          exercices
          liasse_fiscale
          fntp_carte_pro
          qualibat
          probtp
          msa_cotisations
          bilans_entreprise_bdf
          certificat_rge_ademe
          actes_inpi
          bilans_inpi
          eori_douanes
        ]
      }
    end
    # rubocop:enable Metrics/MethodLength

    def user_for_valid_jwt
      JwtTokenService.new(jwt: jwt(:valid)).jwt_user
    end
  end
end

def yes_jwt
  # A jwt meant to not trigger any auth error or permissions exceptions
  # We use it in controllers to test functionality, 2xx, 404 and >, 5xx
  # The 403 behaviour should be tested with nope_jwt
  # But the 401 behaviour should be tested with forged jwt
  JwtHelper.jwt(:valid)
end

def yes_jwt_with_scopes
  JwtHelper.jwt(:with_scopes_not_roles)
end

def expired_jwt
  JwtHelper.jwt(:expired)
end

def unsigned_jwt
  JwtHelper.jwt(:unsigned)
end

def forged_jwt
  JwtHelper.jwt(:forged)
end

def yes_jwt_user
  JwtTokenService.new(jwt: yes_jwt).jwt_user
end

def corrupted_jwt
  JwtHelper.jwt(:corrupted)
end

def nope_jwt
  JwtHelper.jwt(:no_roles)
end

def uptime_jwt
  JwtHelper.jwt(:uptime)
end
