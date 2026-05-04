class ApplicationInteractor
  include Interactor
  include MockedDataHelper

  def self.raises(error_class, **)
    ErrorRegistry.register(self, error_class, **)
  end

  def self.declares_no_specific_errors!
    ErrorRegistry.mark_guarded(self)
  end
end
