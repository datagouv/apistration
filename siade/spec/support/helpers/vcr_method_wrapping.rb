def wrap_with_vcr(klass, method_name, cassette_proc, method_for_cassette_proc_args)
  klass.instance_eval do
    method_name = method_name.to_s

    define_method("#{method_name}_with_vcr_wrap") do |*args|
      VCR.use_cassette(cassette_proc.call(self.send(method_for_cassette_proc_args))) do
        self.send("#{method_name}_without_vcr_wrap",*args)
      end
    end

    alias_method("#{method_name.to_s}_without_vcr_wrap",method_name)
    alias_method(method_name,"#{method_name}_with_vcr_wrap")
  end
end

# TODO SHould wrap all drivers perform // call to requests

wrap_with_vcr(SIADE::V2::Drivers::Infogreffe, :perform_request, Proc.new { |siren| "infogreffe_soap_call_siren#{siren}" }, :siren)

wrap_with_vcr(SIADE::V2::Drivers::CotisationsMSA, :response, Proc.new { |siret| "msa_webservice_rest_siret_call_#{siret}" }, :siret)
