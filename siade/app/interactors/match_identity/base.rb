class MatchIdentity::Base < ApplicationInteractor
  def call
    context.matchings ||= {}
    context.matchings[identifier] = match?
  end

  protected

  def match?
    fail NotImplementedError
  end

  private

  def identifier
    self.class.name.split('::')[-1].downcase
  end
end
