require 'time'

module ApplicationHelper
  def show_navigation?
    user_signed_in? && current_user.registration_complete?
  end

  def current_account
    case current_user
    when AccountUser then current_user.account
    else @account || (@unit && @unit.account)
    end
  end

  def current_unit
    case current_user
    when UnitUser then current_user.unit
    else @unit
    end
  end

  def nav_link(*args, &block)
    options = block_given? ? args.first : args.second
    class_name = active_if?(current_page?(options))
    content_tag :li, class: class_name do
      link_to(*args, &block)
    end
  end

  def nav_section?(name)
    controller.controller_name == name.pluralize || params["#{name}_id"]
  end

  def active_if?(condition)
    condition ? 'active' : ''
  end

  def delete_icon
    content_tag :i, nil, class: 'vs vs-trash'
  end

  def edit_icon
    content_tag :i, nil, class: 'vs vs-cog'
  end

  def suspend_icon
    content_tag :i, nil, class: 'fa fa-remove text-warning'
  end

  def unsuspend_icon
    content_tag :i, nil, class: 'vs vs-check text-success'
  end

  def boolean_icon(condition)
    if condition
      content_tag :i, nil, class: 'vs vs-check text-success'
    else
      content_tag :i, nil, class: 'fa fa-remove fa-lg text-danger'
    end
  end

  def on_off(condition)
    condition ? 'On' : 'Off'
  end

  def remove_from(form)
    link_to_remove_association(delete_icon, form, class: 'btn btn-default')
  end

  def edit_button(model, url = nil)
    if policy(model).edit?
      url ||= url_for [:edit, model]
      link_to url, class: 'btn btn-default', title: 'Edit' do
        edit_icon
      end
    end
  end

  def destroy_button(model, url = nil)
    if policy(model).destroy?
      url ||= url_for model
      link_to url, method: :delete, class: 'btn btn-default', title: 'Delete', data: { confirm: 'Are you sure?' } do
        delete_icon
      end
    end
  end

  def suspend_toggle(model, url = nil)
    url ||= url_for model
    if !model.suspended? && policy(model).suspend?
      link_to "#{url}/suspend", method: :post, class: 'btn btn-default' do
        suspend_icon
      end
    elsif model.suspended? && policy(model).unsuspend?
      link_to "#{url}/unsuspend", method: :post, class: 'btn btn-default' do
        unsuspend_icon
      end
    end
  end

  def label_group(label, value = nil, options = {}, &block)
    value = value.to_s
    content_for(:label, label, flush: true)
    block ||= -> { value.present? ? value : 'n/a' }
    render layout: 'shared/label_group', locals: { options: options }, &block
  end

  def yield_content!(content_key)
    view_flow.content.delete(content_key)
  end
end
