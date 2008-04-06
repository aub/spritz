namespace :test do
  desc 'Tracks test coverage with rcov'
  task :coverage do
    unless PLATFORM['i386-mswin32']
      rm_f "coverage"
      rm_f "coverage.data"
      rcov = "rcov --sort coverage --rails --aggregate coverage.data --exclude spec " +
             "--text-summary -Ilib -T -x gems/*,rcov*"
      specs = FileList['spec/**/*_spec.rb']
      system("#{rcov} --html #{specs.join(" ")}")
    else
      rm_f "coverage"
      rm_f "coverage.data"
      rcov = "rcov.cmd --sort coverage --rails --aggregate coverage.data --exclude spec " +
             "--text-summary -Ilib -T"
      specs = FileList['spec/**/*_spec.rb']
      system("#{rcov} --html #{specs.join(" ")}")
    end
  end
end