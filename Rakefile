require 'yaml'
require 'ap'


STDOUT.sync = true

BANDS_YML = "locals/bands.yml"

task :deploy do
  system "git push origin master"
  system "rsync -avzP bands drop:amfmf13"
  system 'ssh drop "cd ~/amfmf13 && git pull && npm install && forever restartall"'
end

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
    resize 640, 80
  end

  desc "Resize 320x"
  task "320" do
    resize 320, 80
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
      color = output.match(/#([\dA-F]{6})/)[1].hex
      inverse = color ^ 0xFFFFFF
      band = File.basename(filename, File.extname(filename))
      colors[band] = {
        color: "##{color.to_s(16)}",
        inverse: "##{inverse.to_s(16)}"
      }
    end
  end
  colors
end

namespace :colors do

  desc "Extract colors"
  task :extract do
    colors = extract_colors
    bands = YAML.load_file(BANDS_YML)
    bands.each do |band|
      band["color"] = colors[band["slug"]]["color"]
      band["inverse"] = colors[band["slug"]]["inverse"]
    end
    File.open(BANDS_YML, 'w+') { |f| f.write(bands.to_yaml) }
  end

end