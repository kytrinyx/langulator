def cleanup(file)
  FileUtils.rm(file) if File.exists? file
end

Before('@compile') do
  cleanup AGGREGATE_FILE
end

After('@compile') do
  cleanup AGGREGATE_FILE
end

Before('@decompile') do
  INDIVIDUAL_FILES.each {|f| cleanup f}

end

After('@decompile') do
  INDIVIDUAL_FILES.each {|f| cleanup f}
end
