class Admins::RegistrationsController < Devise::RegistrationsController
  undef new
  undef create
end
