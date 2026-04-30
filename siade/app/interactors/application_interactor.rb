class ApplicationInteractor
  include Interactor
  include MockedDataHelper

  def self.raises(error_class, **)
    ErrorRegistry.register(self, error_class, **)
  end
end
