# frozen_string_literal: true

module RuboCop
  module Cop
    module Custom
      class LazyLookupInSharedHandler < Base
        MSG = 'Use an absolute i18n key: a lazy lookup (`t(\'.key\')`) here resolves ' \
              'against whichever controller and action is running, not this file.'
        RESTRICT_ON_SEND = %i[t translate].freeze
        BASE_CLASS_FILE = %r{(/app/controllers/[a-z_]+_controller|/base_controller|/app/mailers/application_mailer)\.rb\z}

        def_node_matcher :lazy_lookup_call?, <<~PATTERN
          (send {nil? self} _ ${str dstr sym dsym} ...)
        PATTERN

        def_node_matcher :rescue_from_call?, <<~PATTERN
          {(send nil? :rescue_from ...) (block (send nil? :rescue_from ...) ...)}
        PATTERN

        def_node_search :rescue_from_handler_names, <<~PATTERN
          (send nil? :rescue_from ... (hash <(pair (sym :with) (sym $_)) ...>))
        PATTERN

        def on_new_investigation
          @rescue_from_handlers = rescue_from_handler_names(processed_source.ast).to_a if processed_source.ast
        end

        def on_send(node)
          key = lazy_lookup_call?(node)
          return unless key && relative_key?(key)
          return unless in_base_class_file? || in_rescue_from_call?(node) || in_rescue_from_handler?(node)

          add_offense(node)
        end

        private

        def relative_key?(key_node)
          leading_part = key_node.type?(:str, :sym) ? key_node : key_node.children.first
          leading_part&.type?(:str, :sym) && leading_part.value.to_s.start_with?('.')
        end

        def in_base_class_file?
          processed_source.file_path.match?(BASE_CLASS_FILE)
        end

        def in_rescue_from_call?(node)
          node.each_ancestor.any? { |ancestor| rescue_from_call?(ancestor) }
        end

        def in_rescue_from_handler?(node)
          node.each_ancestor(:def).any? { |method| Array(@rescue_from_handlers).include?(method.method_name) }
        end
      end
    end
  end
end
