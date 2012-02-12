module StanfordCoreNLP
  class JarLoader
    
    require 'rjb'
    
    # Configuration options.
    class << self
      # An array of flags to pass to the JVM machine.
      attr_accessor :jvm_args
      attr_accessor :jar_path
      attr_accessor :log_file
    end
    
    # An array of string flags to supply to the JVM, e.g. ['-Xms512M', '-Xmx1024M']
    self.jvm_args = []
    # The path in which to look for Jars.
    self.jar_path = ''
    # By default, disable logging.
    self.log_file = nil
      
    # Load Rjb and create Java VM.
    def self.rjb_initialize
      return if ::Rjb::loaded?
      ::Rjb::load(nil, self.jvm_args)
      set_java_logging if self.log_file
    end
   
    # Enable logging.
    def self.log(file = 'log.txt')
      self.log_file = file
    end
     
    # Redirect the output of the JVM to supplied log file.
    def self.set_java_logging
      const_set(:System, Rjb::import('java.lang.System'))
      const_set(:PrintStream, Rjb::import('java.io.PrintStream'))
      const_set(:File2, Rjb::import('java.io.File'))
      ps = PrintStream.new(File2.new(self.log_file))
      ps.write(::Time.now.strftime("[%m/%d/%Y at %I:%M%p]\n\n"))
      System.setOut(ps)
      System.setErr(ps)
    end
    
    # Load a jar.
    def self.load(jar)
      self.rjb_initialize
      jar = self.jar_path + jar
      if !::File.readable?(jar)
        raise "Could not find JAR file (looking in #{jar})."
      end
      ::Rjb::add_jar(jar)
    end
    
  end
end
