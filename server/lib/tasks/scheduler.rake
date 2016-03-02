desc 'This task is called by the Heroku scheduler add-on'


task :import_demo => :environment do
  Tasks::AreaImporterTask.import_demo_area
  Tasks::AreaImporterTask.import_demo_polygons
end
