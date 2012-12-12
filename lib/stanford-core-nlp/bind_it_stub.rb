# bind-it gem mixin state attributes (used for MRI binding)
# TODO refactor/DRY this

module BindItStub

  def self.extended(base)
    super(base)

    base.module_eval do
      class << self
        # Are the default JARs/classes loaded?
        attr_accessor :bound
        # The default path to look in for JARs.
        attr_accessor :jar_path
        # The flags for starting the JVM machine.
        attr_accessor :jvm_args
        # A file to redirect JVM output to.
        attr_accessor :log_file
        # The default JARs to load.
        attr_accessor :default_jars
        # The default Java namespace to 
        # search in for classes.
        attr_accessor :default_namespace
        # The default classes to load.
        attr_accessor :default_classes
      end
      # Set default values.
      self.jar_path = ''
      self.jvm_args = []
      self.log_file = nil
      self.default_namespace = 'java'
      self.default_classes = []
      self.bound = false
    end
  end
end