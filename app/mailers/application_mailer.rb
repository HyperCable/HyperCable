# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: ENV["DEFAULT_MAIL_FROM"] || "no-reply@hackershare.dev"
  layout "mailer"
end
