require 'yaml'
require 'ap'


STDOUT.sync = true

def resize(size, quality)

  size = size.to_s

  # copy original files into size directory
  system "cp -r bands/original/. bands/#{size}"

  # resize images to size and with quality, reformat as jpg
  Dir.chdir 'bands' do
    Dir.entries '.' do |filename|
      unless File.directory? filename
        original_path = "original/#{filename}"
        new_path = "#{size}/#{filename}"
        next if !File.exists?(new_path) || File.mtime(new_path).to_i > File.mtime("original/#{filename}").to_i

        system "mogrify -resize #{size}x -quality #{quality} -format jpg \"#{new_path}\""
        puts "Writing #{filename}"
      end
    end
  end
  # remove cruft
  system "find bands/#{size} -not -name \"*.jpg\" -delete"

end


namespace :resize do

  desc "Resize 1024x"
  task "1024" do
    resize 1024, 80
  end

  desc "Resize 640x"
  task "640" do
    resize 640, 60
  end

  desc "Resize all"
  task all: ["resize:1024", "resize:640"]

end

def extract_colors
  colors = Hash.new
  Dir.chdir 'bands/original' do
    Dir.entries('.').each do |filename|
      next if File.directory? filename
      output = `convert #{filename} -resize 1x1! txt:-`
      color = output.match(/#([\dA-F]{6})/)[1]
      inverse = color.hex ^ 0xFFFFFF
      band = File.basename(filename, File.extname(filename))
      colors[band] = "##{inverse.to_s(16)}"
    end
  end
  colors
end

namespace :colors do

  desc "Extract colors"
  task :extract do
    colors = extract_colors
    bands = YAML.load_file('locals/bands.yml')
    bands.each do |band|
      band["color"] = colors[band["slug"]]
    end
    ap bands
  end

end