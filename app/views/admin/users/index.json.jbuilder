# frozen_string_literal: true

json.array! @admin_users, partial: 'admin_users/admin_user', as: :admin_user
