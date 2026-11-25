module EditorProfileHelper
  def editor_profile_field(form, type, attribute, label, **options)
    editor_profile_input_group(form, attribute, label, hint: options.delete(:hint)) do
      form.public_send(type, attribute, class: 'fr-input', **options)
    end
  end

  def editor_profile_input_group(form, attribute, label, hint: nil, &)
    errors = form.object.errors[attribute]

    content_tag(:div, class: ['fr-input-group', ('fr-input-group--error' if errors.any?)]) do
      safe_join([
        form.label(attribute, class: 'fr-label') { safe_join([label, (content_tag(:span, hint, class: 'fr-hint-text') if hint)].compact) },
        capture(&),
        *errors.map { |message| content_tag(:p, message, class: 'fr-error-text') }
      ])
    end
  end

  def editor_profile_select(form, attribute, label, options)
    content_tag(:div, class: 'fr-select-group') do
      form.label(attribute, label, class: 'fr-label') +
        form.select(attribute, options_for_select(options, form.object.public_send(attribute)), {}, class: 'fr-select')
    end
  end

  def editor_profile_checkbox(form, attribute, label)
    content_tag(:div, class: 'fr-checkbox-group') do
      form.check_box(attribute, class: 'fr-checkbox') + form.label(attribute, label, class: 'fr-label')
    end
  end

  def editor_profile_choices(form, attribute, legend, options, **choice_options)
    errors = form.object.errors[attribute]

    content_tag(:fieldset, class: ['fr-fieldset', ('fr-fieldset--error' if errors.any?)], id: editor_profile_fieldset_id(form, attribute, legend)) do
      safe_join([
        content_tag(:legend, legend, class: 'fr-fieldset__legend fr-fieldset__legend--regular'),
        (hidden_field_tag("#{form.object_name}[#{attribute}][]", '', id: nil) if choice_options[:multiple]),
        *options.map { |choice| editor_profile_choice(form, attribute, choice, **choice_options) },
        *editor_profile_errors(errors)
      ].compact)
    end
  end

  def editor_profile_fieldset_id(form, attribute, legend)
    "#{form.object_name}-#{attribute}-#{legend.parameterize}".dasherize
  end

  def editor_profile_errors(errors)
    errors.map { |message| content_tag(:p, message, class: 'fr-error-text fr-fieldset__element') }
  end

  def editor_profile_remove_button(path, subject, confirmation)
    button_to path, method: :delete, class: 'fr-btn fr-btn--sm fr-btn--tertiary', data: { turbo_confirm: confirmation } do
      editor_profile_action_label('Retirer', subject)
    end
  end

  def editor_profile_edit_link(path, subject)
    link_to editor_profile_action_label('Modifier', subject), path, class: 'fr-btn fr-btn--sm fr-btn--tertiary'
  end

  def editor_profile_action_label(action, subject)
    safe_join([action, content_tag(:span, " #{subject}", class: 'fr-sr-only')])
  end

  def editor_profile_choice(form, attribute, (label, value), multiple: false, input_data: {})
    input_id = "#{form.object_name}_#{attribute}_#{value}"
    input = if multiple
              check_box_tag("#{form.object_name}[#{attribute}][]", value, form.object.public_send(attribute).include?(value), id: input_id, data: input_data)
            else
              form.radio_button(attribute, value, id: input_id, data: input_data)
            end

    content_tag(:div, class: 'fr-fieldset__element fr-fieldset__element--inline') do
      content_tag(:div, class: multiple ? 'fr-checkbox-group' : 'fr-radio-group') do
        input + label_tag(input_id, label, class: 'fr-label')
      end
    end
  end

  def editor_profile_yes_no(form, attribute, legend, **)
    editor_profile_choices(form, attribute, legend, [['Oui', true], ['Non', false]], **)
  end

  def editor_profile_conditional(form, attribute, &)
    content_tag(:div, data: { controller: 'conditional-fields', conditional_fields_name_value: "#{form.object_name}[#{attribute}]" }, &)
  end

  def editor_profile_shown_when(*values, &)
    content_tag(:div, data: { conditional_fields_target: 'field', show_when: values.join(' ') }, &)
  end

  def editor_profile_row(width: 8, &)
    content_tag(:div, class: 'fr-grid-row fr-mb-3w') do
      content_tag(:div, class: "fr-col-12 fr-col-md-#{width}", &)
    end
  end

  def editor_profile_readonly(label, value)
    content_tag(:div, class: 'fr-mb-3w') do
      safe_join([
        content_tag(:p, label, class: 'fr-text--sm fr-text--bold fr-mb-1v'),
        content_tag(:p, value.presence || editor_profile_blank, class: 'fr-mb-0')
      ])
    end
  end

  def editor_profile_blank
    content_tag(:span, 'Non renseigné', class: 'fr-text-mention--grey')
  end
end
