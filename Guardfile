default_guard_options = {
  all_after_pass: false,
  all_on_start: false
}

def run(cmd)
  puts "############################################################"
  puts(cmd)
  puts "############################################################"

  result = system cmd

  if !result
    Notifier.notify("Command: #{cmd}", title: "Failing tests", image: :failed)
  else
    Notifier.notify("Command: #{cmd}", title: "Passing tests", image: :success)
  end
end

def run_strainer
  run "bundle exec strainer test"
end

guard :guard, default_guard_options do
  watch(%r{(.+?)/.*\.(rb|erb)}) { run_strainer }
end

guard :bundler, default_guard_options do
  watch('Gemfile')
end
