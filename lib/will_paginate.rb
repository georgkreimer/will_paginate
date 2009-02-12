require 'active_support'

# = You *will* paginate!
#
# First read about WillPaginate::Finder::ClassMethods, then see
# WillPaginate::ViewHelpers. The magical array you're handling in-between is
# WillPaginate::Collection.
#
# Happy paginating!
module WillPaginate
  class << self
    # shortcut for <tt>enable_actionpack</tt> and <tt>enable_activerecord</tt> combined
    def enable
      enable_actionpack
    end
    
    # hooks WillPaginate::ViewHelpers into ActionView::Base
    def enable_actionpack
      return if ActionView::Base.instance_methods.include? 'will_paginate'
      require 'will_paginate/view_helpers'
      ActionView::Base.send :include, ViewHelpers

      if defined?(ActionController::Base) and ActionController::Base.respond_to? :rescue_responses
        ActionController::Base.rescue_responses['WillPaginate::InvalidPage'] = :not_found
      end
    end

    # Enable named_scope, a feature of Rails 2.1, even if you have older Rails
    # (tested on Rails 2.0.2 and 1.2.6).
    #
    # You can pass +false+ for +patch+ parameter to skip monkeypatching
    # *associations*. Use this if you feel that <tt>named_scope</tt> broke
    # has_many, has_many :through or has_and_belongs_to_many associations in
    # your app. By passing +false+, you can still use <tt>named_scope</tt> in
    # your models, but not through associations.
    def enable_named_scope(patch = true)
      require 'will_paginate/named_scope'
      require 'will_paginate/named_scope_patch' if patch
    end
  end

  module Deprecation # :nodoc:
    extend ActiveSupport::Deprecation

    def self.warn(message, callstack = caller)
      message = 'WillPaginate: ' + message.strip.gsub(/\s+/, ' ')
      ActiveSupport::Deprecation.warn(message, callstack)
    end
  end
end

if defined?(Rails) and defined?(ActionController)
  WillPaginate.enable
end
