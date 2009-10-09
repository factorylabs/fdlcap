class Capistrano::Configuration

  ##
  # Print an informative message with asterisks.

  def inform(message)
    puts "#{'*' * (message.length + 4)}"
    puts "* #{message} *"
    puts "#{'*' * (message.length + 4)}"
  end

  ##
  # Read a file and evaluate it as an ERB template.
  # Path is relative to this file's directory.

  def render_erb_template(filename)
    template = File.read(filename)
    result = ERB.new(template).result(binding)
  end

  ##
  # Run a command and return the result as a string.
  #
  # TODO May not work properly on multiple servers.

  def run_and_return(cmd)
    output = []
    run cmd do |ch, st, data|
      output << data
    end
    return output.to_s
  end

  def try(command, options)
    success = true
    invoke_command(command, options) do |ch, stream, out|
      warn "#{ch[:server]}: #{out}" if stream == :err
      yield ch, stream, out if block_given?
    end
  rescue Capistrano::CommandError => e
    success = false
  end

  def check(cmd, options)
    puts cmd
    puts options
    success = false
    invoke_command("if [#{cmd}]; then echo exists; else echo not_found; fi", options) do |ch, stream, out|
      warn "#{ch[:server]}: #{out}" if stream == :err
      success = out.strip == 'exists' ? true : false
      break if stream == :err
    end
    success
  end

end