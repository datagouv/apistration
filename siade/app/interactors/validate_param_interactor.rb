class ValidateParamInteractor < ApplicationInteractor
  def self.inherited(klass)
    klass.class_eval do
      before do
        context.errors ||= []
      end
    end
  end

  def call
    fail 'should be implemented in inherited class'
  end

  protected

  def invalid_param!(kind)
    context.errors << UnprocessableEntityError.new(kind)

    mark_as_error!
  end

  def param(name)
    params.fetch(name, nil)
  end

  def mark_as_error!
    return if context.wait_to_fail

    context.fail!
  end

  def params
    context.params
  end
end
