Before('@outfile') do
  FileUtils.rm(OUTFILE) if File.exists? OUTFILE
end

After('@outfile') do
  FileUtils.rm(OUTFILE) if File.exists? OUTFILE
end
