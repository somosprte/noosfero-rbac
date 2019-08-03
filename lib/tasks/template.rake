namespace :template do

  task :apply_blocks, [:identifier] => [:environment] do |task, args|
    template = Profile[args[:identifier]]
    template.delay.update_mirrored_profiles_blocks
  end

  task :apply_theme, [:identifier] => [:environment] do |task, args|
    template = Profile[args[:identifier]]
    template.delay.update_mirrored_profiles_theme
  end

  task :apply_all => [:apply_blocks, :apply_theme]

end
