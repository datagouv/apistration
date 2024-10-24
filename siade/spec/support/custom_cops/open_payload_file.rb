require 'rubocop'

# rubocop:disable Style/ClassAndModuleChildren
module RuboCop::Cop::CustomCops
  class OpenPayloadFile < RuboCop::Cop::Base
    MSG = 'Avoid using File.open, File.read, or Rails.root.join with "payloads" in the parameter. Use "read_payload_file" or "open_payload_file" instead'.freeze

    def on_send(node)
      return unless %i[open read join].include?(node.method_name)

      arg = node.arguments.first
      return unless arg&.str_type? && arg.str_content.include?('/payloads/')

      add_offense(node.loc.selector, message: MSG)
    end
  end
end
# rubocop:enable Style/ClassAndModuleChildren
