module JwtHelper
  class << self
    # rubocop:disable Metrics/MethodLength
    def jwt(type = :valid)
      samples = {
        valid: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiIzZDQ3MDZjNC03ZjVlLTQ0NDItYTczNC0wMGQ2YzY3NWYzYzkiLCJzY29wZXMiOlsiYXR0ZXN0YXRpb25zX2FnZWZpcGgiLCJhdHRlc3RhdGlvbnNfZmlzY2FsZXMiLCJhdHRlc3RhdGlvbnNfc29jaWFsZXMiLCJjZXJ0aWZpY2F0X2NuZXRwIiwiYXNzb2NpYXRpb25zIiwiY2VydGlmaWNhdF9vcHFpYmkiLCJkb2N1bWVudHNfYXNzb2NpYXRpb24iLCJldGFibGlzc2VtZW50cyIsImVudHJlcHJpc2VzIiwiZW50cmVwcmlzZXNfYXJ0aXNhbmFsZXMiLCJleHRyYWl0X2NvdXJ0X2lucGkiLCJleHRyYWl0c19yY3MiLCJleGVyY2ljZXMiLCJsaWFzc2VfZmlzY2FsZSIsImZudHBfY2FydGVfcHJvIiwicXVhbGliYXQiLCJwcm9idHAiLCJtc2FfY290aXNhdGlvbnMiLCJiaWxhbnNfZW50cmVwcmlzZV9iZGYiLCJjZXJ0aWZpY2F0X3JnZV9hZGVtZSIsImNlcnRpZmljYXRfYWdlbmNlX2JpbyIsImFjdGVzX2lucGkiLCJiaWxhbnNfaW5waSIsImNvbnZlbnRpb25zX2NvbGxlY3RpdmVzIiwiZW9yaV9kb3VhbmVzIl0sInN1YiI6InRlc3Qgc2lhZGUiLCJpYXQiOjE1OTY3OTE2NTksInZlcnNpb24iOiIxLjAifQ.bRe1CTn6ppO_31OhunZAhzxg8vYKuTwgnOCG3O2NbIY',
        with_roles_not_scopes: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJiYTI2MWY5OC1mMjA0LTQ0ZmYtOGQwYS04MmEzNWEzYjFlYWEiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJyb2xlcyI6WyJkb2N1bWVudHNfYXNzb2NpYXRpb24iLCJhc3NvY2lhdGlvbnMiLCJmbnRwX2NhcnRlX3BybyIsImVudHJlcHJpc2VfYXJ0aXNhbmFsZSIsInVwdGltZSIsInByb2J0cCIsImFpZGVzX2NvdmlkX2VmZmVjdGlmcyIsImV0YWJsaXNzZW1lbnRzIiwiY2VydGlmaWNhdF9jbmV0cCIsImJpbGFuc19lbnRyZXByaXNlX2JkZiIsImNlcnRpZmljYXRfcmdlX2FkZW1lIiwiZXh0cmFpdF9jb3VydF9pbnBpIiwiY2VydGlmaWNhdF9vcHFpYmkiLCJjb252ZW50aW9uc19jb2xsZWN0aXZlcyIsInByaXZpbGVnZXMiLCJhY3Rlc19pbnBpIiwiYmlsYW5zX2lucGkiLCJhdHRlc3RhdGlvbnNfc29jaWFsZXMiLCJtc2FfY290aXNhdGlvbnMiLCJxdWFsaWJhdCIsImF0dGVzdGF0aW9uc19hZ2VmaXBoIiwiZW50cmVwcmlzZXMiLCJleHRyYWl0c19yY3MiLCJlb3JpX2RvdWFuZXMiLCJjZXJ0aWZpY2F0X2FnZW5jZV9iaW8iLCJleHRyYWl0X3JjcyIsImVudHJlcHJpc2UiLCJldGFibGlzc2VtZW50IiwibGlhc3NlX2Zpc2NhbGUiLCJhdHRlc3RhdGlvbnNfZmlzY2FsZXMiLCJleGVyY2ljZXMiLCJlbnRyZXByaXNlc19hcnRpc2FuYWxlcyJdLCJzdWIiOiJ0ZXN0IGRldmVsb3BtZW50IiwiaWF0IjoxNjU1NzIzODk2LCJ2ZXJzaW9uIjoiMS4wIn0.RLky8PtczIDas1A7S7XYDcur3pNs43RzWB2lAtpHKZE',
        expired: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiIzZDQ3MDZjNC03ZjVlLTQ0NDItYTczNC0wMGQ2YzY3NWYzYzkiLCJzY29wZXMiOlsiYXR0ZXN0YXRpb25zX2FnZWZpcGgiLCJhdHRlc3RhdGlvbnNfZmlzY2FsZXMiLCJhdHRlc3RhdGlvbnNfc29jaWFsZXMiLCJjZXJ0aWZpY2F0X2NuZXRwIiwiYXNzb2NpYXRpb25zIiwiY2VydGlmaWNhdF9vcHFpYmkiLCJkb2N1bWVudHNfYXNzb2NpYXRpb24iLCJldGFibGlzc2VtZW50cyIsImVudHJlcHJpc2VzIiwiZW50cmVwcmlzZXNfYXJ0aXNhbmFsZXMiLCJleHRyYWl0X2NvdXJ0X2lucGkiLCJleHRyYWl0c19yY3MiLCJleGVyY2ljZXMiLCJsaWFzc2VfZmlzY2FsZSIsImZudHBfY2FydGVfcHJvIiwicXVhbGliYXQiLCJwcm9idHAiLCJtc2FfY290aXNhdGlvbnMiLCJiaWxhbnNfZW50cmVwcmlzZV9iZGYiLCJjZXJ0aWZpY2F0X3JnZV9hZGVtZSIsImFjdGVzX2lucGkiLCJiaWxhbnNfaW5waSIsImNvbnZlbnRpb25zX2NvbGxlY3RpdmVzIiwiZW9yaV9kb3VhbmVzIl0sInN1YiI6InRlc3Qgc2lhZGUiLCJpYXQiOjE1OTY3OTE2NTksImV4cCI6MTU5Njc5MTY1OSwidmVyc2lvbiI6IjEuMCJ9.zZq9y579m6lGOQN8SyrpgTZ449kZ7XLXwOTIWqF3Z5o',
        unsigned: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiIzZDQ3MDZjNC03ZjVlLTQ0NDItYTczNC0wMGQ2YzY3NWYzYzkiLCJzY29wZXMiOlsiYXR0ZXN0YXRpb25zX2FnZWZpcGgiLCJhdHRlc3RhdGlvbnNfZmlzY2FsZXMiLCJhdHRlc3RhdGlvbnNfc29jaWFsZXMiLCJjZXJ0aWZpY2F0X2NuZXRwIiwiYXNzb2NpYXRpb25zIiwiY2VydGlmaWNhdF9vcHFpYmkiLCJkb2N1bWVudHNfYXNzb2NpYXRpb24iLCJldGFibGlzc2VtZW50cyIsImVudHJlcHJpc2VzIiwiZW50cmVwcmlzZXNfYXJ0aXNhbmFsZXMiLCJleHRyYWl0X2NvdXJ0X2lucGkiLCJleHRyYWl0c19yY3MiLCJleGVyY2ljZXMiLCJsaWFzc2VfZmlzY2FsZSIsImZudHBfY2FydGVfcHJvIiwicXVhbGliYXQiLCJwcm9idHAiLCJtc2FfY290aXNhdGlvbnMiLCJiaWxhbnNfZW50cmVwcmlzZV9iZGYiLCJjZXJ0aWZpY2F0X3JnZV9hZGVtZSIsImFjdGVzX2lucGkiLCJiaWxhbnNfaW5waSIsImNvbnZlbnRpb25zX2NvbGxlY3RpdmVzIiwiZW9yaV9kb3VhbmVzIl0sInN1YiI6InRlc3Qgc2lhZGUiLCJpYXQiOjE1OTY3OTE2NTksImV4cCI6MTU5Njc5MTY1OSwidmVyc2lvbiI6IjEuMCJ9.',
        forged: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI0YzYzYzlkOS0xOGRjLTRhNjMtYTU1NS1kZTg3ZjY0M2YyYzAiLCJzY29wZXMiOlsic2NvcGVfMyIsInNjb3BlXzQiXX0.xN4pL4WrVKjjmTfswrwS4D5rwxO2IGKt2JBPO-H_qrE',
        corrupted: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI0YzYzYzlkOS0xOGRjLTRhNjMtYTU1NSgdfgd1kZTg3ZjY0M2YyYzAiLCJyb2xlcyI6WyJyb2wzIiwicm9sNCJdfQ.28Zo8dOMOxd4G5-nR-sfmNlbqRnSvbRbVkVto6i50gI',
        no_scopes: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiJiMTU3OGRhMC01MmZlLTRiY2EtYmZhYy1iNWUxODNlOWU3MWMiLCJzY29wZXMiOltdLCJzdWIiOiJOTyBKV1QiLCJpYXQiOjE1ODAzMDMxMjAsInZlcnNpb24iOiIxLjAifQ.heqyFhIhMvQq8pJ6WCBfwf1LsjgCyeOyI0kFA68t_po',
        without_uuid_as_jti: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJmNWQ1Y2IwMi0xODVhLTQyNmYtYjNmNC05OWEyNWNlNmNkZjQiLCJqdGkiOiJpbnZhbGlkIiwic2NvcGVzIjpbIndoYXRldmVyIl0sInN1YiI6InRlc3Qgc2lhZGUiLCJpYXQiOjE1OTY3OTE2NTksInZlcnNpb24iOiIxLjAifQ.rWjLDH1PPO5Tn_hspCHihv4v0YWKwMEbuyntFYidspE',
        without_uuid_as_uid: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiJpbnZhbGlkIiwianRpIjoiM2Q0NzA2YzQtN2Y1ZS00NDQyLWE3MzQtMDBkNmM2NzVmM2M5Iiwic2NvcGVzIjpbIndoYXRldmVyIl0sInN1YiI6InRlc3Qgc2lhZGUiLCJpYXQiOjE1OTY3OTE2NTksInZlcnNpb24iOiIxLjAifQ.cPAhKr947zIv-OLSuKGNletkiQucCF9J3I-d8MvmZd0',
        uptime: 'eyJhbGciOiJIUzI1NiJ9.eyJ1aWQiOiI3M2FmYTU0ZS04YzkxLTQ2NjctYmQyYS0xMDFhOGI4NjUxMjgiLCJqdGkiOiIwMDAwMDAwMC0wMDAwLTAwMDAtMDAwMC0wMDAwMDAwMDAwMDAiLCJzY29wZXMiOlsidXB0aW1lIl0sInN1YiI6InRlc3QgZGV2ZWxvcG1lbnQiLCJpYXQiOjE2NTEyMzYxNjksInZlcnNpb24iOiIxLjAifQ.85dEGIKjRaGRNaxG-ou5_xZ9SyKoJ2W8iMTrhy4TwR8'
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
        scopes: %w[
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
  end
end

def all_scopes
  Rails.application.config_for(:authorizations).values.flatten.uniq
end

def yes_jwt
  @yes_jwt ||= TokenFactory.new(all_scopes).valid(
    uid: 'f5d5cb02-185a-426f-b3f4-99a25ce6cdf4'
  )
end

def yes_jwt_with_roles
  JwtHelper.jwt(:with_roles_not_scopes)
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
  JwtTokenService.new(yes_jwt).extract_user
end

def corrupted_jwt
  JwtHelper.jwt(:corrupted)
end

def nope_jwt
  JwtHelper.jwt(:no_scopes)
end

def uptime_jwt
  JwtHelper.jwt(:uptime)
end
